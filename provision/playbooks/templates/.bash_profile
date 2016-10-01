#
# The .bash_profile for VCCW
#

if [ -d "${HOME}/.bash.d" ] ; then
  for f in "${HOME}"/.bash.d/*.sh ; do
    source "$f"
  done
  unset f
fi
