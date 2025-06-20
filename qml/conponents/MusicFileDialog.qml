import QtQuick
import QtQuick.Dialogs
import QtQuick.Controls
import Qt.labs.folderlistmodel

Item{
    id:mfDialog
    signal filesSelected(var filePaths)
    property alias filesDialog: selectMusicsDialog
    property alias folderDialog: _folderDialog
    property var selectedFilePaths: []

    //选择多个文件
    FileDialog {
        id: selectMusicsDialog
        title:"请选择音乐文件"
        nameFilters: ["音乐文件 (*.mp3 *.wav *.flac *.ogg)", "所有文件 (*)"]
        fileMode: FileDialog.OpenFiles

        onAccepted:{
            selectedFilePaths = []  // 清空旧数据
            for (var i = 0; i <selectMusicsDialog.selectedFiles.length; i++) {
                var fileUrl = selectMusicsDialog.selectedFiles[i].toString()
                var filePath = fileUrl.replace("file://", "")
                selectedFilePaths.push(filePath)
            }
            mfDialog.filesSelected(selectedFilePaths)
        }
    }

    //选择文件夹
    FolderDialog{
        id:_folderDialog
        currentFolder: Qt.resolvedUrl("file:///")  // 设置默认打开目录为根目录
        onAccepted:{
            const selectFolder = _folderDialog.selectedFolder.toString()
            console.log(selectFolder)
            processFolder(selectFolder)
        }
    }

    FolderListModel {
        id: folderModel
        folder: ""
        showDirs: false
        showFiles: true
        nameFilters: ["*.mp3", "*.wav", "*.ogg", "*.flac"]

        onStatusChanged: {
            if (status === FolderListModel.Ready) {
                // 模型加载完成后处理文件
                //selectedFilePaths = []
                for (var i = 0; i < folderModel.count; i++) {
                    if (!isFolder(i)) {
                        selectedFilePaths.push(get(i, "filePath"))
                    }
                }
                //console.log("模型加载完成，找到文件:", selectedFilePaths.length)
                mfDialog.filesSelected(selectedFilePaths)
            }
        }
    }

    function processFolder(folderUrl) {
        folderModel.folder = folderUrl
        console.log("xxxxxxxxx", folderUrl)
    }
}
