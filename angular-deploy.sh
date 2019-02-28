#!/bin/bash


env=$1

cd /path/to/local/project/folder

if [ "$env" == "production" ]; then
server_ip=""
server_key=""
folder_path=/path/to/builds/folder/
elif [ "$env" == "qa" ]
then
server_ip=0.0.0.0
server_key=/path/to/ssh/key/key.pem
folder_path=/path/to/builds/folder/
elif [ "$env" == "dev" ]
then
server_ip=0.0.0.0
server_key=/path/to/ssh/key/key.pem
folder_path=/path/to/builds/folder/
else
# Nothing
echo 'Nothing'
fi

ng build --configuration=$env
build_suffix=`date +%d%m%Y-%H%M`
uncompressed_file="build_$build_suffix"
compressed_file="build_$build_suffix.tgz"
mv dist "$uncompressed_file"
echo "$compressed_file"
tar cvfz "$compressed_file" "$uncompressed_file"
scp -i "$server_key" "$compressed_file" ubuntu@"$server_ip":"$folder_path""$compressed_file"

rm -rf "$compressed_file"
rm -rf "$uncompressed_file"
ssh -i "$server_key" ubuntu@"$server_ip" << EOF
cd "$folder_path"
tar xfz "$compressed_file"
rm "$compressed_file"
EOF


# rm current
# ln -s "$folder_path""$uncompressed_file" current
