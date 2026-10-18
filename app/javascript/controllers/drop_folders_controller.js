import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // console.log(this.element)
    // this.element.addEventListener("drop", function(event) {
    //   event.preventDefault();

    //   var items = event.dataTransfer.items;
    //     for (var i=0; i<items.length; i++) {
    //         // webkitGetAsEntry is where the magic happens
    //         var item = items[i].webkitGetAsEntry();
    //         if (item) {
    //             traverseFileTree(item);
    //         }
    //     }
    // }, false);

    this.element.addEventListener('drop', async function (event) {
        event.preventDefault();
        // console.log(event)
        // console.log(event.dataTransfer.items[0])
        // console.log("pre")
        let items = await getAllFileEntries(event.dataTransfer.items);
        // console.log(items)
        items.forEach((item) => {
          const originFullPath = item.fullPath

          item.file(function(file) {
            // const lastModifiedDate = new Date(file.lastModified);

            // console.log(`Last Modified Date: ${lastModifiedDate}`);


            uploadFile(file, originFullPath)
          })
          //   console.log(item.fullPath)
          // uploadFile(item)
        })
    });

    this.element.addEventListener(
        "dragover",
        function(event) {
            event.preventDefault();
        },
    false);

    // this.element.ondrop = function(e) {
    //     var length = e.dataTransfer.items.length;
    //     for (var i = 0; i < length; i++) {
    //         var entry = e.dataTransfer.items[i].webkitGetAsEntry();
    //         if (entry.isFile) {
    //         console.log(entry)
    //         } else if (entry.isDirectory) {
    //         console.log(entry)
    //         }
    //     }
    //     };
  }
}

// function traverseFileTree(item, path) {
//   path = path || "";
//   if (item.isFile) {
//     // Get file
//     item.file(function(file) {
//       console.log("File:", path + file.name);
//     });
//   } else if (item.isDirectory) {
//     // Get folder contents
//     var dirReader = item.createReader();
//     dirReader.readEntries(function(entries) {
//       for (var i=0; i<entries.length; i++) {
//         traverseFileTree(entries[i], path + item.name + "/");
//       }
//     });
//   }
// }


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
