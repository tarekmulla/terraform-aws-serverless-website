function handler(event) {
    var request = event.request;
    request.uri = request.uri.replace(/^\/[^/]*\//, "/");
    return request;
}
