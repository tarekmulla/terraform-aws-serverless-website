// A lambda layer for all shared methods between lambda functions

function generateHeaders() {
  const headers = {
    'Access-Control-Allow-Origin': '*',
    'Content-Type': 'application/json'
  };
  return headers;
}

function apiResponse(res) {
  const headers = generateHeaders();
  return {
    headers,
    statusCode: res.statusCode,
    body: JSON.stringify(res.payload),
  };
}

function jsonEscape(str)  {
  // Preserve newlines, etc. - use valid JSON
  newStr = str.replace(/\\n/g, "\\n")
    .replace(/\\'/g, "\\'")
    .replace(/\\"/g, '\\"')
    .replace(/\\&/g, "\\&")
    .replace(/\\r/g, "\\r")
    .replace(/\\t/g, "\\t")
    .replace(/\\b/g, "\\b")
    .replace(/\\f/g, "\\f");
  // Remove non-printable and other non-valid JSON characters
  newStr = newStr.replace(/[\u0000-\u0019]+/g, "");
  return newStr;
}


module.exports = {
  apiResponse,
  jsonEscape
};
