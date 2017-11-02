import os
import sys
import hashlib

import mutagen


def md5(fname):
    hash_md5 = hashlib.md5()
    with open(fname, "rb") as f:
        for chunk in iter(lambda: f.read(4096), b""):
            hash_md5.update(chunk)
    return hash_md5.hexdigest()


def main(argv):
    script_dir = os.path.dirname(os.path.realpath(__file__))
    output_dir = os.path.join(script_dir, "output")
    for entry in sorted(os.listdir(output_dir)):
        file_path = os.path.join(output_dir, entry)
        info = mutagen.File(file_path).info
        # print(md5(file_path))
        print("%-45s %-18s %-3s %-6s %-10s" % (
            entry, info.encoder_info, str(info.bitrate_mode).split(".")[-1],
            info.bitrate // 1000, info.encoder_settings))


if __name__ == "__main__":
    sys.exit(main(sys.argv))
