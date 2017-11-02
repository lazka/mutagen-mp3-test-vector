#!/bin/bash

output="output"

rm -Rf "${output}"
mkdir -p "${output}"

for source in mono_16k mono_44k stereo_16k  stereo_32k stereo_44k stereo_48k; do

    for version in 3.70 3.88 3.89 3.90.1 3.91 3.92 3.93.1 3.94b1 3.95.1 3.96.1 3.97 3.98.2 3.98.4 3.99.5 3.100a2 3.100; do

        for v in 0 1 2 3 4 5 6 7 8 9 2.5; do
            ./encoders/lame-$version --vbr-old -V${v} ${source}.wav "${output}/${source}_lame_${version}_vbr_old_v${v}.mp3"
            ./encoders/lame-$version --vbr-new -V${v} ${source}.wav "${output}/${source}_lame_${version}_vbr_new_v${v}.mp3"
            ./encoders/lame-$version -V${v} ${source}.wav "${output}/${source}_lame_${version}_vbr_v${v}.mp3"
        done

        for preset in medium standard extreme insane r3mix phone voice fm tape hifi cd studio; do
            ./encoders/lame-$version --preset ${preset} ${source}.wav "${output}/${source}_lame_${version}_preset_${preset}.mp3"
            ./encoders/lame-$version --preset fast ${preset} ${source}.wav "${output}/${source}_lame_${version}_preset_fast_${preset}.mp3"
            ./encoders/lame-$version --alt-preset ${preset} ${source}.wav "${output}/${source}_lame_${version}_alt_preset_${preset}.mp3"
        done

        for abr in 32 66 112 128 160 192 254 280 300 320; do
            ./encoders/lame-$version --abr ${abr} ${source}.wav "${output}/${source}_lame_${version}_abr_${abr}.mp3"
            ./encoders/lame-$version --preset ${abr} ${source}.wav "${output}/${source}_lame_${version}_preset_${abr}.mp3"
            ./encoders/lame-$version --alt-preset ${abr} ${source}.wav "${output}/${source}_lame_${version}_alt_preset_${abr}.mp3"
        done

        for cbr in 32 40 48 56 64 112 128 160 192 224 256 320; do
            ./encoders/lame-$version --preset cbr ${cbr} ${source}.wav "${output}/${source}_lame_${version}_preset_cbr_${cbr}.mp3"
            ./encoders/lame-$version -b ${cbr} ${source}.wav "${output}/${source}_lame_${version}_b_${cbr}.mp3"
        done
    done

    wine ./encoders/fhg-1.5.exe -m 0 -br 128000 -if ${source}.wav -of ${output}/${source}_fhg_1.5_cbr_128.mp3
    wine ./encoders/fhg-1.5.exe -m 0 -br 96000 -if ${source}.wav -of ${output}/${source}_fhg_1.5_cbr_96.mp3
    wine ./encoders/fhg-1.5.exe -m 0 -br 320000 -if ${source}.wav -of ${output}/${source}_fhg_1.5_cbr_320.mp3
    wine ./encoders/fhg-1.5.exe -m 1 -br 0 -vbri -q 0 -if ${source}.wav -of ${output}/${source}_fhg_1.5_vbr_m1_q0.mp3
    wine ./encoders/fhg-1.5.exe -m 1 -br 0 -vbri -q 1 -if ${source}.wav -of ${output}/${source}_fhg_1.5_vbr_m1_q1.mp3
    wine ./encoders/fhg-1.5.exe -m 2 -br 0 -vbri -if ${source}.wav -of ${output}/${source}_fhg_1.5_vbr_m2.mp3
    wine ./encoders/fhg-1.5.exe -m 3 -br 0 -vbri -if ${source}.wav -of ${output}/${source}_fhg_1.5_vbr_m3.mp3
    wine ./encoders/fhg-1.5.exe -m 4 -br 0 -vbri -if ${source}.wav -of ${output}/${source}_fhg_1.5_vbr_m4.mp3
    wine ./encoders/fhg-1.5.exe -m 5 -br 0 -vbri -if ${source}.wav -of ${output}/${source}_fhg_1.5_vbr_m5.mp3

    wine ./encoders/helix-5.1.exe ${source}.wav ${output}/${source}_helix_5.1_vbr_0.mp3 -X -V0
    wine ./encoders/helix-5.1.exe ${source}.wav ${output}/${source}_helix_5.1_vbr_50.mp3 -X -V50
    wine ./encoders/helix-5.1.exe ${source}.wav ${output}/${source}_helix_5.1_vbr_100.mp3 -X -V100
    wine ./encoders/helix-5.1.exe ${source}.wav ${output}/${source}_helix_5.1_vbr_150.mp3 -X -V150
done

find "${output}" -size 0 -delete
