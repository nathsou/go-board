import { runYosys, type RunOptions, type Tree } from 'npm:@yowasp/yosys@0.41.68-dev.720';
import { runNextpnrIce40, runIcepack } from 'npm:@yowasp/nextpnr-ice40@0.8.39-dev.540';
import { z } from 'https://deno.land/x/zod@v3.23.8/mod.ts';
import { parseArgs } from "jsr:@std/cli/parse-args";
import * as path from "https://deno.land/std@0.224.0/path/mod.ts";

const flags = parseArgs(Deno.args, {
  string: ['board', 'top'],
});

if (flags._.length !== 1 || flags.top == null || flags.board == null) {
  console.log(`Usage: deno run main.ts <project folder> --top <top module name> --board <board name>`);
  Deno.exit(1);
}

const boardSchema = z.object({
    name: z.string(),
    chip: z.string(),
    package: z.string(),
    pcf_path: z.string(),
    freq: z.number().optional(),
});

type Board = z.infer<typeof boardSchema>;

const boardDefPath = path.join(import.meta.dirname ?? '', `${flags.board}`);
const boardJson = await Deno.readTextFile(boardDefPath);
const boardDef = boardSchema.parse(JSON.parse(boardJson));
const pcfPath = path.join(import.meta.dirname ?? '', boardDef.pcf_path);
const pcfFile = await Deno.readTextFile(pcfPath);

async function listVerilogFiles(dir: string): Promise<Record<string, string>> {
    const files: Record<string, string> = {};

    for await (const file of await Deno.readDir(dir)) {
        if (file.isFile && file.name.endsWith('.v') || file.name.endsWith('.sv')) {
            const contents = await Deno.readTextFile(path.join(dir, file.name));
            files[file.name] = contents;
        } else if (file.isDirectory) {
            const subFiles = await listVerilogFiles(path.join(dir, file.name));
            Object.assign(files, subFiles);
        }
    }

    return files;
}

const files = await listVerilogFiles(String(flags._[0]));

const VERBOSE = true;

const stdioHandlers: RunOptions = {
    stdout(bytes) {
        if (VERBOSE && bytes !== null) {
            Deno.stdout.write(bytes);
        }
    },
    stderr(bytes) {
        if (VERBOSE && bytes !== null) {
            Deno.stderr.write(bytes);
        }
    },
};

type GenerateBitstreamInput = {
    topModuleName: string,
    files: Tree,
    board: Board,
    pcf: string,
};

const generateBitstream = async ({ topModuleName, files, board, pcf }: GenerateBitstreamInput) => {
    const verilogFiles = Object.keys(files).filter((filename) => filename.endsWith('.v')).join(' ');

    const yosysFilesOut = await runYosys(
        ['-p', `read_verilog ${verilogFiles}; synth_ice40 -top ${topModuleName} -json out.json`],
        files,
        stdioHandlers,
    );

    if (yosysFilesOut == null || !('out.json' in yosysFilesOut)) {
        throw new Error('Yosys failed to generate a .json file');
    }
    const jsonFile = yosysFilesOut['out.json'];

    console.log(jsonFile);
    console.log('Running nextpnr-ice40');

    const pnrFilesOut = await runNextpnrIce40(
        [
            `--${board.chip}`,
            '--json', 'out.json',
            '--pcf', 'pins.pcf',
            '--package', board.package,
            '--freq', `${board.freq}`,
            '--asc', 'out.asc',
        ],
        {
            'out.json': jsonFile,
            'pins.pcf': pcf,
        },
        stdioHandlers,
    );

    const ascFile = pnrFilesOut['out.asc'];

    const icepackFilesOut = await runIcepack(
        ['out.asc', 'out.bin'],
        {
            'out.asc': ascFile,
        },
        stdioHandlers,
    );

    const binFile = icepackFilesOut['out.bin'];

    return {
        'json': jsonFile,
        'asc': ascFile,
        'bin': binFile,
    };
};

const res = await generateBitstream({
  files,
  board: boardDef,
  pcf: pcfFile,
  topModuleName: flags.top,
});

if (res.bin instanceof Uint8Array) {
  Deno.writeFileSync('out.bin', res.bin);
}

