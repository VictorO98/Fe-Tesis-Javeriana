import axios from "axios";

const api = "http://157.230.83.145";
// const api = "http://localhost:5000"

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