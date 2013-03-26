##
## This is used as part of continuous integration via Travis CI.
##

## Load TFGM
begin
	load './../lib/tfgm.rb'
rescue TFGM_Error, JSON
	Kernel.exit 1
end