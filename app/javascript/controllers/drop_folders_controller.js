import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.addEventListener('drop', async function (event) {
        event.preventDefault();
        let items = await getAllFileEntries(event.dataTransfer.items);

        items.forEach((item) => {
          const originFullPath = item.fullPath

          item.file(function(file) {


            uploadFile(file, originFullPath)
          })
        })
    });

    this.element.addEventListener(
        "dragover",
        function(event) {
            event.preventDefault();
        },
    false);
  }
}

// Drop handler function to get all files
async function getAllFileEntries(dataTransferItemList) {
  let fileEntries = [];
  // Use BFS to traverse entire directory/file structure
  let queue = [];
  // Unfortunately dataTransferItemList is not iterable i.e. no forEach
  for (let i = 0; i < dataTransferItemList.length; i++) {
    // Note webkitGetAsEntry a non-standard feature and may change
    // Usage is necessary for handling directories
    queue.push(dataTransferItemList[i].webkitGetAsEntry());
  }
  while (queue.length > 0) {
    let entry = queue.shift();
    if (entry.isFile) {
      fileEntries.push(entry);
    } else if (entry.isDirectory) {
      let reader = entry.createReader();
      queue.push(...await readAllDirectoryEntries(reader));
    }
  }
  return fileEntries;
}

// Get all the entries (files or sub-directories) in a directory by calling readEntries until it returns empty array
async function readAllDirectoryEntries(directoryReader) {
  let entries = [];
  let readEntries = await readEntriesPromise(directoryReader);
  while (readEntries.length > 0) {
    entries.push(...readEntries);
    readEntries = await readEntriesPromise(directoryReader);
  }
  return entries;
}

// Wrap readEntries in a promise to make working with readEntries easier
async function readEntriesPromise(directoryReader) {
  try {
    return await new Promise((resolve, reject) => {
      directoryReader.readEntries(resolve, reject);
    });
  } catch (err) {
    console.log(err);
  }
}


function uploadFile(file, originFullPath) {
  let url = '/import_legacy_files';
  let formData = new FormData();

  formData.append('file', file);
  formData.append('filename', file.name);
  formData.append('filesize', file.size);
  formData.append('last_modified_at', file.lastModified);
  formData.append('origin_filepath', originFullPath);

  fetch(url, {
    method: 'POST',
    body: formData
  })
  .then(() => {
    console.log('Archivo subido correctamente:', file.name);
  })
  .catch(() => {
    console.error('Error al subir el archivo:', file.name);
  });
}
