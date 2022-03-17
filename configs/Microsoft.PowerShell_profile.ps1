Invoke-Expression (&starship init powershell)

#region conda initialize
# !! Contents within this block are managed by 'conda init' !!
# (& "C:\Users\yamat\anaconda3\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | Invoke-Expression
#endregion

& 'C:\Users\yamat\anaconda3\shell\condabin\conda-hook.ps1';
conda activate 'C:\Users\yamat\anaconda3'