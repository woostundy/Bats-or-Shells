for /L %%i in (1,1,1000) do (
     for /f "tokens=* skip=27" %%b (%%i.htm) do (
             echo %%b >>All.html
    )
)
pause