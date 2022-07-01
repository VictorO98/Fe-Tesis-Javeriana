<template>
  <div class="container">
    <br />
    <div class="col-md-12">
      <h5>
        <b> CONFIRMAR CUENTA </b>
      </h5>
      <b
        >Bienvenido a Buy@, haga click en el siguiente botón para confirmar la
        cuenta.
      </b>
      <p>Email: {{ obj.email }}</p>
      <br />
      <loading v-model:active="isLoading" :can-cancel="true" />
      <button @click="onSubmit" class="submit-btn" type="submit">
        CONFIRMAR CUENTA
      </button>
    </div>
  </div>
</template>

<script>
import { reactive, ref } from "vue";
import Loading from "vue-loading-overlay";
import "vue-loading-overlay/dist/vue-loading.css";
import { useRoute } from "vue-router";
import * as Services from "../util/services";

export default {
  name: "ConfirmarCuenta",

  components: {
    Loading,
  },
  setup() {
    const route = useRoute();
    let obj = reactive({ email: route.params.email, isLoading: false });
    let form = {};
    let isLoading = ref(false);
    const title = process.env.VUE_APP_TITLE;

    function onSubmit(values) {
      form = Object.assign(values, {
        code: route.params.token.join("/"),
        email: obj.email,
      });
      isLoading.value = true;

      Services.post("/api/Authenticate/ConfirmarCuenta", form)
        .then((data) => {
          if (data?.data.codigo == 10) alert(data.data.mensaje);
        })
        .catch((err) => {
          if (err.response.data?.codigo == 20) {
            alert("ERROR: " + err.response.data.mensaje);
          } else {
            alert("OCURRIÓ UN ERROR");
          }
        })
        .finally(() => {
          isLoading.value = false;
        });
    }

    return {
      onSubmit,
      obj,
      isLoading,
      title,
    };
  },
};
</script>

<style>
* {
  box-sizing: border-box;
}

:root {
  --primary-color: #0091a7;
  --error-color: #f23648;
  --error-bg-color: #fddfe2;
  --success-color: #21a67a;
  --success-bg-color: #e0eee4;
}

html,
body {
  width: 100%;
  height: 100%;
}

#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #2c3e50;
  margin-top: 60px;

  width: 100%;
  height: 100%;
}

form {
  width: 300px;
  margin: 0px auto;
  padding-bottom: 60px;
}

.submit-btn {
  background: var(--primary-color);
  outline: none;
  border: none;
  color: #fff;
  font-size: 18px;
  padding: 10px 15px;
  display: block;
  width: 30%;
  position: absolute;
  border-radius: 20px;
  left: 36%;
  margin-top: 40px;
  transition: transform 0.3s ease-in-out;
  cursor: pointer;
}

.submit-btn:hover {
  transform: scale(1.1);
}
</style>
