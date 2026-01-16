@REM Start PHD2 and connect devices if not already running/connected
@REM This must happen BEFORE NINA starts
@set "PHD2_PROFILE=C8E+2600+EQ6+DSO"
@REM Uncomment and set the correct profile name for your equipment:
@set "PHD2_PATH=C:\Program Files (x86)\PHDGuiding2\phd2.exe"
python3.14 start-phd2.py --profile "%PHD2_PROFILE%" --phd2-path "%PHD2_PATH%"
@if errorlevel 1 (
    @echo Warning: PHD2 startup or device connection failed
    @REM Continue anyway - PHD2 might still work
)

timeout /t 5

@REM start NINA
python3.14 start-nina.py --config config.start-nina.json
