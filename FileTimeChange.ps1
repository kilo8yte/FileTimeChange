[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")


$CreationDate2set=$null
$ChangeDate2set=$null
$AccessDate2set=$null
$FilesSelected=$null

$mainWindow = New-Object System.Windows.Forms.Form
$mainWindow.Text="FileTimeChange"
$mainWindow.StartPosition = "CenterScreen"
$mainWindow.MaximizeBox=$false
$mainWindow.Size = New-Object System.Drawing.Size(400,500)

$ButtonFiles2open=New-Object System.Windows.Forms.Button
$ButtonFiles2open.Text="Dateien auswählen"
$ButtonFiles2open.Size = New-Object System.Drawing.Size(200,70)
$ButtonFiles2open.Location= New-Object System.Drawing.Point(100,10)


$TextBoxSelectedFiles=New-Object System.Windows.Forms.TextBox
$TextBoxSelectedFiles.Multiline=$true
$TextBoxSelectedFiles.Size = New-Object System.Drawing.Size(350,100)
$TextBoxSelectedFiles.Location= New-Object System.Drawing.Point(20,90)
$TextBoxSelectedFiles.ReadOnly=$true
$TextBoxSelectedFiles.ScrollBars=[ System.Windows.Forms.RichTextBoxScrollBars]::Vertical


$CheckBoxCreationDate=New-Object System.Windows.Forms.CheckBox
$CheckBoxCreationDate.Location=New-Object System.Drawing.Point(20,200)
$CheckBoxCreationDate.Text="Erstelldatum"
$CheckBoxCreationDate.Width=150

$CheckBoxChangeDate=New-Object System.Windows.Forms.CheckBox
$CheckBoxChangeDate.Location= New-Object System.Drawing.Point(20,250)
$CheckBoxChangeDate.Text="Änderungsdatum"
$CheckBoxChangeDate.Width=150

$CheckBoxAccessDate=New-Object System.Windows.Forms.CheckBox
$CheckBoxAccessDate.Location=New-Object System.Drawing.Point(20,300)
$CheckBoxAccessDate.Text="Letzter Zugriff"
$CheckBoxAccessDate.Width=150

$TextBoxCreationDate=New-Object System.Windows.Forms.TextBox
$TextBoxCreationDate.Location=New-Object System.Drawing.Point(170,200)
$TextBoxCreationDate.Width=100
$TextBoxCreationDate.Enabled=$false;


$TextBoxCreationTime=New-Object System.Windows.Forms.TextBox
$TextBoxCreationTime.Location=New-Object System.Drawing.Point(290,200)
$TextBoxCreationTime.Width=80
$TextBoxCreationTime.Enabled=$false;

$TextBoxChangeDate=New-Object System.Windows.Forms.TextBox
$TextBoxChangeDate.Location=New-Object System.Drawing.Point(170,250)
$TextBoxChangeDate.Width=100
$TextBoxChangeDate.Enabled=$false;


$TextBoxChangeTime=New-Object System.Windows.Forms.TextBox
$TextBoxChangeTime.Location=New-Object System.Drawing.Point(290,250)
$TextBoxChangeTime.Width=80
$TextBoxChangeTime.Enabled=$false;

$TextBoxAccessDate=New-Object System.Windows.Forms.TextBox
$TextBoxAccessDate.Location=New-Object System.Drawing.Point(170,300)
$TextBoxAccessDate.Width=100
$TextBoxAccessDate.Enabled=$false;


$TextBoxAccessTime=New-Object System.Windows.Forms.TextBox
$TextBoxAccessTime.Location=New-Object System.Drawing.Point(290,300)
$TextBoxAccessTime.Width=80
$TextBoxAccessTime.Enabled=$false;

$ButtonSetDate=New-Object System.Windows.Forms.Button
$ButtonSetDate.Text="Attribute setzen"
$ButtonSetDate.Size = New-Object System.Drawing.Size(150,60)
$ButtonSetDate.Location= New-Object System.Drawing.Point(125,380)

$mainWindow.Controls.Add($ButtonFiles2open)
$mainWindow.Controls.Add($CheckBoxCreationDate)
$mainWindow.Controls.Add($CheckBoxChangeDate)
$mainWindow.Controls.Add($CheckBoxAccessDate)
$mainWindow.Controls.Add($TextBoxCreationDate)
$mainWindow.Controls.Add($TextBoxChangeDate)
$mainWindow.Controls.Add($TextBoxAccessDate)
$mainWindow.Controls.Add($TextBoxCreationTime)
$mainWindow.Controls.Add($TextBoxChangeTime)
$mainWindow.Controls.Add($TextBoxAccessTime)
$mainWindow.Controls.Add($ButtonSetDate)
$mainWindow.Controls.Add($TextBoxSelectedFiles)

$ButtonFiles2open.Add_Click({
    $FilesSelected=New-Object System.Windows.Forms.OpenFileDialog
    $FilesSelected.Multiselect=$true
    
    [bool]$button=$FilesSelected.ShowDialog()

    if($button -eq $true){
        #[System.Windows.Forms.MessageBox]::Show($msg,"Titel",0)
        foreach( $file in $FilesSelected.FileNames){
            if($TextBoxSelectedFiles.Lines.Count-eq 0){
                $TextBoxSelectedFiles.Text += $file
                 
            }else{
                $TextBoxSelectedFiles.Text += "`r`n"+ $file
            
            }
        }
    }
})

$ButtonSetDate.Add_Click({
    if($CheckBoxCreationDate.Checked){
        #$CreationDate2set=New-Object System.DateTime
        try{
            $CreationDate2set= [datetime]::parse($TextBoxCreationDate.Text+" "+$TextBoxCreationTime.Text)
        }catch{
            [System.Windows.Forms.MessageBox]::Show("Falsches Format","Erstelldatum",0,[System.Windows.Forms.MessageBoxIcon]::Error)
        }
    }
    if($CheckBoxChangeDate.Checked){
        try{
            $ChangeDate2set = [datetime]::parse($TextBoxChangeDate.Text+" "+$TextBoxChangeTime.Text)
            }catch{
                [System.Windows.Forms.MessageBox]::Show("Falsches Format","Änderungsdatum",0,[System.Windows.Forms.MessageBoxIcon]::Error)
            }
    }
    if($CheckBoxAccessDate.Checked){
        try{
            $AccessDate2set = [datetime]::parse($TextBoxChangeDate.Text+" "+$TextBoxChangeTime.Text)
            }catch{
                [System.Windows.Forms.MessageBox]::Show("Falsches Format","Zugriffsdatum",0,[System.Windows.Forms.MessageBoxIcon]::Error)
            }
    }
    $donewithouterror=$true
    for($i=0;$i-lt$TextBoxSelectedFiles.Lines.Count;$i++){
        if($CheckBoxCreationDate.Checked){
            if($CreationDate2set -ne $null){
                try{
                    $(Get-Item $TextBoxSelectedFiles.Lines[$i]).CreationTime=$CreationDate2set
                }catch{
                    $donewithouterror=$false
                }
            }
        }
        if($CheckBoxChangeDate.Checked){
            if($ChangeDate2set -ne $null){
                try{
                    $(Get-Item $TextBoxSelectedFiles.Lines[$i]).LastWriteTime=$ChangeDate2set
                }catch{
                    $donewithouterror=$false
                }
            }
        }
        if($CheckBoxAccessDate.Checked){
            if($AccessDate2set -ne $null){
                try{
                    $(Get-Item $TextBoxSelectedFiles.Lines[$i]).LastAccessTime=$AccessDate2set
                }catch{
                    $donewithouterror=$false
                }
            }
        }
    }
    
    if($donewithouterror -and $TextBoxSelectedFiles.Lines.Count -gt 0){
        [System.Windows.Forms.MessageBox]::Show("Änderungen erfolgreich durchgeführt","Änderungen der Zeitstempel",0)
        $TextBoxSelectedFiles.Text=""
        $TextBoxCreationDate.Text=""
        $TextBoxCreationTime.Text=""
        $TextBoxChangeDate.Text=""
        $TextBoxChangeTime.Text=""
        $TextBoxAccessDate.Text=""
        $TextBoxAccessTime.Text=""
        $CheckBoxCreationDate.Checked=$false
        $CheckBoxChangeDate.Checked=$false
        $CheckBoxAccessDate.Checked=$false
    }elseif($donewithouterror -eq $false -and $TextBoxSelectedFiles.Lines.Count -gt 0){
        [System.Windows.Forms.MessageBox]::Show("Änderungen mit fehlern beendet. Nicht alle Zeitstempel konnten angepasst werden","Änderungen der Zeitstempel",0,[System.Windows.Forms.MessageBoxIcon]::Error)
    }


})

$CheckBoxCreationDate.Add_CheckStateChanged({
    $value=$false
    if($CheckBoxCreationDate.Checked){
        $value=$true
    }
    $TextBoxCreationDate.Enabled=$value
    $TextBoxCreationTime.Enabled=$value
})

$CheckBoxChangeDate.Add_CheckStateChanged({
    $value=$false
    if($CheckBoxChangeDate.Checked){
        $value=$true
    }
    $TextBoxChangeDate.Enabled=$value
    $TextBoxChangeTime.Enabled=$value
})

$CheckBoxAccessDate.Add_CheckStateChanged({
    $value=$false
    if($CheckBoxAccessDate.Checked){
        $value=$true
    }
    $TextBoxAccessDate.Enabled=$value
    $TextBoxAccessTime.Enabled=$value
})


$mainWindow.ShowDialog()



