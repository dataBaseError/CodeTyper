
def checkForwardSlash(folder)
    if folder[-1] != "/"
        folder = "#{folder}/"
    end
    folder
end