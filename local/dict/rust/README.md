# rust

## module list generator
```
pushd tmp
../racer_list.sh "std" | tee ../rust_std_modules.txt
TRAVERSE_MAX_LEVEL=1 ../racer_list.sh "anyhow" | sed 's/format_err/anyhow/g' | tee ../rust_anyhow_modules.txt
echo 'thiserror::Error' > ../rust_thiserror_modules.txt
cat ../rust_*_modules.txt > ../rust_modules.txt
popd
```
