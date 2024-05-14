# gaze *.cise -c "sh ./tran.sh {{file}}"

tmux send-keys -t 'OUT' "clear && echo '....'" Enter
dotnet run > out.log 2>&1

errstate=$?

msg="$(head -1 out.log)"

cat out.log 

if [ $errstate -eq 0 ] ; then
    tmux send-keys -t 'OUT' "clear && echo 'OK: $msg'" Enter
else
    tmux send-keys -t 'OUT' 'echo Fail' Enter
fi
