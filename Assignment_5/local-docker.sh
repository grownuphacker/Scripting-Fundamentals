docker run --rm -v ./samples/:/autograder/submission -v ./output:/autograder/results -v D:\code\Scripting-Fundamentals\Assignment_5\build\:/autograder/source/ -v D:\code\Scripting-Fundamentals\Assignment_5\build\run_autograder:/autograder/run_autograder -v  D:\code\Scripting-Fundamentals\Assignment_5\build\setup.sh:/autograder/setup.sh gradescope/autograder-base:latest /autograder/setup.sh && cat ./results.json