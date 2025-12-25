# .bashrc
# vimrc
#alias vim-l='VIM_PROFILE=light vim'

#alias vim-w='VIM_PROFILE=weight vim'

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
alias gv="gvim"
alias g="gvim"
alias la="ls -a"
alias ..="cd ../"
cd() { builtin cd "$@" && ls; }

export PS1='[\u@\h `pwd`]\$'


########################
# EDA environment
########################

# SYNOPSYS ####################################################################################################################
#############
# EDA PATH
#############
export SCL_HOME=/home/jjt/install/synopsys/scl/scl/2021.03
export VCS_HOME=/home/jjt/install/synopsys/vcs/vcs/T-2022.06
export VERDI_HOME=/home/jjt/install/synopsys/verdi/verdi/T-2022.06
export DC_HOME=/home/jjt/install/synopsys/dc/syn/T-2022.03-SP2
export PT_HOME=/home/jjt/install/synopsys/pt/prime/T-2022.03
export FM_HOME=/home/jjt/install/synopsys/fm/fm/T-2022.03
export ICC2_HOME=/home/jjt/install/synopsys/icc2/icc2/T-2022.03
#export LC_HOME=/home/jjt/install/synopsys2020/lc2020/lc/R-2020.09-SP5
export SPYGLASS_HOME=/home/jjt/install/synopsys/spyglass/spyglass/T-2022.06-1/SPYGLASS_HOME
export STARRC_HOME=/home/jjt/install/synopsys/starrc/starrc/T-2022.03-SP2

#SCL
PATH=$PATH:$SCL_HOME/linux64/bin

#VCS
PATH=$PATH:$VCS_HOME/bin
alias vcs="vcs"
alias dve="dve -full64"

#VERDI
PATH=$PATH:$VERDI_HOME/bin
alias verdi="verdi"

#DC
PATH=$PATH:$DC_HOME/bin
alias dc="dc_shell"

#PT
PATH=$PATH:$PT_HOME/bin
alias pt="primetime"

#FM
PATH=$PATH:$FM_HOME/bin
alias fm="formality"

#ICC2
PATH=$PATH:$ICC2_HOME/bin
alias icc2="icc2_shell"

#LC
PATH=$PATH:$LC_HOME/bin
alias lc="lc_shell"

#SPYGLASS
PATH=$PATH:$SPYGLASS_HOME/bin
alias spyglass="spyglass"

#STARRC
PATH=$PATH:$STARRC_HOME/bin
alias starrc="starrc_shell"

############
# LICENSE
############
export LM_LICENSE_FILE=27000@localhost.localdomain
alias lmg_synopsys="/home/jjt/install/synopsys/scl/scl/2021.03/linux64/bin/lmgrd -c /home/jjt/install/synopsys/scl/scl/2021.03/admin/license/Synopsys.dat"
####export SNPSLMD_LICENSE_FILE=27000@localhost.localdomain
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/lib64

# Cadence #########################################################################################################################
###########
# EDA PATH
###########
export INNOVUS_HOME=/home/jjt/install/cadence/innovus/innovus2020
export LD_LIBRARY_PATH=${INNOVUS_HOME}/tools.lnx86/lib/64bit:${INNOVUS_HOME}/tools.lnx86
export PATH=${PATH}:${INNOVUS_HOME}/tools.lnx86/bin

alias innovus="innovus"

###########
# LICENSE
###########
export LM_LICENSE_FILE=$LM_LICENSE_FILE:/home/jjt/install/cadence/cadence.dat
alias lmg_cadence="/home/jjt/install/ocad/tools/licsrv/bin/bin.cds/lmgrd -c /home/jjt/install/cadence/cadence.dat"


# Mentor ########################################################################################################################
###########
# EDA PATH
###########
export CALIBRE_HOME=/home/jjt/install/mentor/calibre/calibre2022.2/aoj_cal_2022.2_38.20
export TESSENT_HOME=/home/jjt/install/mentor/tessent_2023_1

# calibre
export PATH=$PATH:$CALIBRE_HOME/bin
export MGC_LIB_PATH=$CALIBRE_HOME/lib:$TESSENT_HOME/lnx-x86/lib64:$TESSENT_HOME/lnx-x86/bin64
export USE_CALIBRE_VCO=aoj

alias calibre="calibre -gui"

# tessent
export PATH=$PATH:$TESSENT_HOME/bin
alias tessent="tessent -shell"

###########
# LICENSE
###########
export LM_LICENSE_FILE=$LM_LICENSE_FILE:/home/jjt/install/mentor/license/license.dat
alias lmg_mentor="/home/jjt/install/mentor/tessent_2023_1/bin/lmgrd -c /home/jjt/install/mentor/license/license.dat"

alias kill_lmg="sudo killall lmgrd"
alias relmg="kill_lmg && lmg_synopsys && lmg_cadence"




export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
source /opt/rh/devtoolset-11/enable

#dotgit
alias dotgit='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

# ===== dotfiles modular config =====
[ -f ~/.bash_aliases ] && source ~/.bash_aliases
[ -f ~/.bash_env ] && source ~/.bash_env

