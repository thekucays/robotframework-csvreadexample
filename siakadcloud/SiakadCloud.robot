*** Settings ***
Suite Teardown    Close All Browsers
Library           Selenium2Library
Library           Collections
Library           CSVLibrary

*** Test Cases ***
Login
    ### read csv data for config
    @{config}=    Read Csv File To Associative    appconfig.csv
    ### heading to login page
    ${mainBrowser}=    Open Browser    &{config[0]}[url]    chrome
    Selenium2Library.Maximize Browser Window
    ### input login data and submit
    Log To Console    >>> start login for username: &{config[0]}[username]
    Selenium2Library.Wait Until Element Is Visible    //*[@id="userid"]    timeout=30s
    Selenium2Library.Input Text    //*[@id="userid"]    &{config[0]}[username]
    Selenium2Library.Input Password    //*[@id="password"]    &{config[0]}[pwd]
    Selenium2Library.Wait Until Element Is Visible    //h2[text()="Silakan Login"]/following-sibling::form/div[3]/button[1]
    Selenium2Library.Click Element    //h2[text()="Silakan Login"]/following-sibling::form/div[3]/button[1]
    ### wait until landed to homepage
    Selenium2Library.Wait Until Element Is Visible    //ul[@id="navigation"]/li[1]    timeout=30s
    Log To Console    >>> username &{config[0]}[username] logged in successfully

Enter Presensi Kelas
    ### pre defined variables
    ${periode}=    Set Variable    20191
    ${kurikulum}=    Set Variable    2019
    ${kode}=    Set Variable    7172
    ### input sim akademik page
    Selenium2Library.Click Element    //ul[@id="navigation"]/li[1]
    Selenium2Library.Wait Until Element Is Visible    //div[@id="siakad"]/div/div[@class="role_box"]    timeout=30s
    Selenium2Library.Click Element    //div[@id="siakad"]/div/div[@class="role_box"]
    ### enter kelas kuliah menu
    Selenium2Library.Wait Until Element Is Visible    //li[@class="dropdown"][2]/a    timeout=30s
    Selenium2Library.Click Element    //li[@class="dropdown"][2]/a
    Selenium2Library.Click Element    //li[@class="dropdown"][2]/ul/li[2]/a
    Selenium2Library.Click Element    //li[@class="dropdown"][2]/ul/li[2]/ul/li
    Page Should Contain    Kelas Kuliah
    Log to console    >>> landed on kelas kuliah page
    ### choose periode akademik
    Selenium2Library.Select From List By Value    //select[@id="periode"]    ${periode}
    ### choose kurikulum
    Selenium2Library.Select From List By Value    //select[@id="kurikulum"]    ${kurikulum}
    ### validate kolom kode (kode mata kuliah)
    Selenium2Library.Wait Until Element Is Visible    //*[@id="form_list"]/div[1]/table/tbody/tr    timeout=30s
    ${kode_matkul}=    Selenium2Library.Get Text    //*[@id="form_list"]/div[1]/table/tbody/tr/td[2]
    Should Be Equal As Strings    ${kode_matkul}    ${kode}    ignore_case=True
    Log To Console    >>> kode matkul: ${kode} found.
    ### click actions
    Selenium2Library.Click Element    //*[@id="form_list"]/div[1]/table/tbody/tr/td[11]/div/button
    Selenium2Library.Wait Until Element Is Visible    //a[text()="Presensi Kelas"]    timeout=30s
    Selenium2Library.Click Element    //a[text()="Presensi Kelas"]
    Page Should Contain    Presensi Kelas
    Log To Console    >>> Landed on Presensi Kelas page. Periode ${periode}. Kurikulum ${kurikulum}. Kode ${kode}
    Sleep    5s

Isi Absensi
    ### pre defined variables
    ${jadwal}=    Set Variable    Selasa, 1 Okt 2019
    ### pre defined variables buat contoh
    ${nim}=    Set Variable    0240310116
    ${presensi}=    Set Variable    A
    ${nim2}=    Set Variable    0247310117
    ${presensi2}=    Set Variable    A
    ### open presensi kelas popup
    Log To Console    >>> Opening presensi kelas popup: ${jadwal}
    Selenium2Library.Wait Until Element Is Visible    //td[text()="${jadwal}"]/following-sibling::td[8]/button    timeout=30s
    Selenium2Library.Click Element    //td[text()="${jadwal}"]/following-sibling::td[8]/button
    Selenium2Library.Wait Until Element Is Visible    //div[@class="modal-content"]/div[3]/button    timeout=30s
    Log To Console    >>> presensi kelas popup opened.
    ### pick student nim and assign presence data
    Selenium2Library.Wait Until Element Is Visible    //td[text()="${nim}"]    timeout=30s
    Selenium2Library.Select From List By Value    //td[text()="${nim}"]/following-sibling::td[2]/span/select    ${presensi}
    Selenium2Library.Wait Until Element Is Visible    //td[text()="${nim2}"]    timeout=30s
    Selenium2Library.Select From List By Value    //td[text()="${nim2}"]/following-sibling::td[2]/span/select    ${presensi2}
    Sleep    10s

test read csv
    @{list}=    Read Csv File To List    appconfig.csv
    Log    hasil read csv file to list: ${list[0]}
    ### baca test.csv
    Comment    @{test}=    Read Csv File To Associative    test.csv
    @{test}=    Read Csv File To List    test.csv
    : FOR    ${key}    IN    @{test}
    \    Log    nim: ${key[0]}
    \    Log    presence: ${key[1]}
