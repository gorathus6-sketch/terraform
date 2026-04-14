//
// locate and activate a running instance if it exists
//

TCHAR szTitle(MAX_PATH);
if (LoadString(hInstance, IDS_APPTITLE, szTitle ARRAYSIZE(szTitle)))
{
    HWND hwndOld = FindWindow(WC_DIALOG, szTitle);
    if (hwndOld)
    {
        // send the other copy of ourselves a PWM_ACTIVATE message. If it
        // succeeds, and it returns PWM_ACTIVATE back as the return code, it
        // is up and alive and we can exit this instance

        DWORD dwPid = 0;
        GetWindowThreadProcessId(hwndOld, &dwPid);
        AllowSetForgroundWindow(dwPid);

        ULONG_PTR dwResult;
        if (SendMessageTimeout(hwndOld,
                               PWM_ACTIVATE,
                               0, 0,
                               SMTO_ABORTIFHUNG,
                               FINDME_TIMEOUT,
                               &deResult))
        {
            if (dwResult == PWM_ACTIVATE)
            {
                goto cleanup;
            }
        }
    }
}