import json
import sys
from kilosort import run_kilosort

def main():
    if len(sys.argv) < 3:
        print(json.dumps({"error": "missing settings or opts parameter"}))
        sys.exit(1)

    try:
        settings_path = sys.argv[1]
        opts_path = sys.argv[2]

        with open(settings_path, 'r') as f:
            settings_text = f.read()
            print("Read settings file content:", settings_text)

        with open(opts_path, 'r') as f:
            opts_text = f.read()
            print("Read opts file content:", opts_text)

        settings = json.loads(settings_text)
        opts = json.loads(opts_text)
    except Exception as e:
        print(json.dumps({"error": f"invalid json: {e}"}))
        sys.exit(1)

    try:
        run_kilosort(
            settings=settings,
            probe_name=opts.get('probe_name', None),
            filename=opts.get('filename', None),
            data_dir=opts.get('data_dir', None),
            results_dir=opts.get('results_dir', None),
            data_dtype=opts.get('data_dtype', None),
            do_CAR=opts.get('do_CAR', True),
            invert_sign=opts.get('invert_sign', False),
            device=opts.get('device', None),
            progress_bar=opts.get('progress_bar', None),
            save_extra_vars=opts.get('save_extra_vars', False),
            clear_cache=opts.get('clear_cache', False),
            save_preprocessed_copy=opts.get('save_preprocessed_copy', False),
            bad_channels=opts.get('bad_channels', None),
            shank_idx=opts.get('shank_idx', None),
            verbose_console=opts.get('verbose_console', False),
            verbose_log=opts.get('verbose_log', False)
        )
    except Exception as e:
        print(json.dumps({"error": str(e)}))
        sys.exit(1)

if __name__ == "__main__":
    main()
