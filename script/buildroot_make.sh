
buildroot_path=buildroot

if [ -d "$buildroot_path" ]; then
  echo "File has exit..."
#  exit
else
  git clone https://github.com/buildroot/buildroot.git
fi
