import axios from "axios";

const api = "http://159.65.216.80";


const get = (path, parameters = null) => {
    return axios.get(api + path, {
        params: parameters
    });
}

const post = (path, body = {}) => {
    return axios.post(api + path, body);
}

export {
    get,
    post
}