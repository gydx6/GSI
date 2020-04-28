#!/bin/sh
set -xa

#-------------------------------------------------------
#
#  diag2grad_ps_case.sh
#
#-------------------------------------------------------

echo "-->  diag2grad_ps_case.sh"

   echo "CONMON_SUFFIX   = $CONMON_SUFFIX"
   echo "TANKDIR_conmon  = $TANKDIR_conmon"
   echo "type            = $type"
   echo "PDATE           = $PDATE"
   echo "EXECconmon      = $EXECconmon"
   echo "cycle           = $cycle"
   echo "nreal           = $nreal"
   echo "mtype           = $mtype (type = $type)"
   echo "subtype         = $subtype"
   echo "hint            = $hint"
   echo "workdir         = $workdir"
   echo "INPUT_FILE    = ${INPUT_FILE}"

   echo "CONMON_NETCDF = ${CONMON_NETCDF}"

   netcdf=.false.
   if [[ ${CONMON_NETCDF} -eq 1 ]]; then
     netcdf=.true.
   end if

   ctype=`echo ${mtype} | cut -c3-5`
   nreal_ps=$nreal                 ### one less than the data items of diagnostic files
   nreal2_ps=`expr $nreal - 2`     ### the data items in the grads files 


if [ "$mtype" = 'ps180' -o "$mtype" = 'ps181' -o  "$mtype" = 'ps183' -o  "$mtype" = 'ps187' ]; then
   rm -f diag2grads
   cp $EXECconmon/conmon_grads_sfctime.x ./diag2grads
   rm -f input
cat <<EOF >input
      &input
       input_file=${INPUT_FILE},intype=' ps',stype='${mtype}',itype=$ctype,nreal=$nreal_ps,
       iscater=1,igrads=1,timecard='time11',subtype='${subtype}',isubtype=${subtype},netcdf=${netcdf},
/
EOF
elif [ "$mtype" = 'ps120' ]; then
   rm -f diag2grads
   cp ${EXECconmon}/conmon_grads_sfc.x ./diag2grads
   rm -f input
cat <<EOF >input
      &input
       input_file=${INPUT_FILE},intype=' ps',stype='${mtype}',itype=$ctype,nreal=$nreal_ps,
       iscater=1,igrads=1,subtype='${subtype}',isubtype=${subtype},netcdf=${netcdf},
/
EOF
fi

./diag2grads <input>stdout 2>&1 

rm -f ${mtype}_${subtype}.tmp


##############################################
#  Create the nt file, rename stdout, move nt,
#  grads, and scatter files to $TANDIR_conmon
##############################################
ntline=`tail -n1 stdout`
nt=`echo ${ntline} | sed 's/^ *//g' | sed 's/ *$//g'`
if [ ${#nt} = 1 ]; then
   ntfile="nt_${mtype}_${subtype}.${PDATE}"
   echo ${nt} > ${ntfile}
   cp ${ntfile} ${TANKDIR_conmon}/horz_hist/${cycle}/.
fi
 
mv stdout stdout_diag2grads_${mtype}_${subtype}.$cycle
dest_dir="${TANKDIR_conmon}/horz_hist/${cycle}"

for file in ps*grads; do 
   mv ${file} ${dest_dir}/${file}.${PDATE}
done

for file in ps*scater; do
   mv ${file} ${dest_dir}/${file}.${PDATE}
done


echo "<--  diag2grad_ps_case.sh"

exit