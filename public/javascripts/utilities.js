function extractLast(term) {
  return split(term).pop();
}

function split(value, delimiter) {
  if (delimiter == undefined) delimiter = ',';
  splitRegex = new RegExp('\s*' + delimiter + '\s*');
  return value.split(splitRegex);
}
