WORKING_DIR=/opt/factorio
SAVE_DIR=$WORKING_DIR/saves
LOG_DIR=$WORKING_DIR/log
LOG=factorio.log

 function error_exit
        {
            print "- FATAL ERROR"
            print "- $1"
            print "- $2"
            print "- program exiting"
            exit 1
        }

 function fatal_error
	{
	    echo "FATAL : $1 , exiting"
	    exit 1
	}


 function check_dir
        {
            cd $1 || error_exit "Log directory - KO -" "Cannot find directory $1 !" 2>&1
        }

 function check_file
	{
	    ls $1 || error_exit "Log file - KO -" "Cannot find file $1 !" 2>&1
	}

 function check_user
	{
	    if [ `id -un` != "factorio" ];
	    then
	      print "Only user factorio can perform check_saved, exiting."
	      exit 1
	    fi
	}

 function check_saved_game
	{
	    cd $WORKING_DIR/saves
	    GAMES=`ls -t | grep .zip`
	    ORIGIN=MP_0.14.12.zip
	    for file in $GAMES
		do
		    print "checking $file"
		    if [[ $file == $ORIGIN ]];
		    then
			print "game correctly saved !"
			break
		    else
			print "$file was not correctly formed"
			print "initiate move"
			rm $ORIGIN
			mv $file $ORIGIN
			check_file $ORIGIN
			print "move done, now last save is set to $ORIGIN"
			break
		   fi
		done
	}
 function print
	{
	    echo "--- $(date +"%d-%m-%Y:%H:%M:%S") --- $1" >> $LOG_DIR/$LOG
	}

 function credits
	{
	    print "-------------------------------------------------------"
	    print "program : game_checker / author : malone / release: 1.0"
	    print "-------------------------------------------------------"
	}

 function check_log
	{
	    cd $LOG_DIR || fatal_error "LOG directory is missing"
	    ls $LOG || (echo 'log file --> factorio.log is missing, going to create it'; echo '#log file created' | tee $LOG )
	}


# main
check_log
credits
print "Welcome to saved game checker"
print "check user..."
check_user >> $LOG_DIR/$LOG
print "user is OK..."
print "check working directory..."
check_dir $WORKING_DIR >> $LOG_DIR/$LOG
print "directory is OK ..."
print "check save directory..."
check_dir $SAVE_DIR >> $LOG_DIR/$LOG
print "directory is OK ..."
print "all prerequisite are accomplished, now checking saved ..."
check_saved_game  >> $LOG_DIR/$LOG
print "saved games are OK ..."
print "all operation are done, goodbye"
exit 0


