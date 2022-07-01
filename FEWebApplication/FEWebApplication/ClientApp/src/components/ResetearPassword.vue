<template>
  <div class="container">
    <br />
    <div class="col-md-12">
      <h5>
        <b> RESTAURAR CONTRASEÑA </b>
      </h5>
      <p>Email: {{ obj.email }}</p>
      <br />
      <Form @submit="onSubmit" :validation-schema="schema">
        <TextInput
          name="password"
          type="password"
          label="Nueva contraseña"
          placeholder="Ingrese su nueva contraseña"
          success-message="Contraseña segura"
        />
        <TextInput
          name="confirmPassword"
          type="password"
          label="Confirmar contraseña"
          placeholder="Por favor confirme la contraseña"
          success-message="Confirmación correcta"
        />
        <loading v-model:active="isLoading" :can-cancel="true" />
        <button class="submit-btn" type="submit">RESTAURAR CONTRASEÑA</button>
      </Form>
    </div>
  </div>
</template>

<script>
import { Form } from "vee-validate";
import * as Yup from "yup";
import TextInput from "./Form/TextInput.vue";
import { useRoute } from "vue-router";
import { reactive, ref } from "vue";
import Loading from "vue-loading-overlay";
import "vue-loading-overlay/dist/vue-loading.css";
// import axios from "axios";
import * as Services from "../util/services";

export default {
  name: "ResetearPassword",

  components: {
    TextInput,
    Form,
    Loading,
  },
  setup() {
    const route = useRoute();
    let obj = reactive({ email: route.params.email, isLoading: false });
    let form = {};
    let isLoading = ref(false);

    function onSubmit(values) {
      form = Object.assign(values, {
        token: route.params.token.join("/"),
        email: obj.email,
      });

      isLoading.value = true;

      Services.post("/api/Authenticate/RecuperarPassword", form)
        .then((data) => {
          console.log("B3", data);
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

    // Using yup to generate a validation schema
    // https://vee-validate.logaretm.com/v4/guide/validation#validation-schemas-with-yup
    let schema = Yup.object().shape({
      email: Yup.string().email().required(),
      password: Yup.string().min(8, "Mínimo 8 caractéres"),
      confirmPassword: Yup.string()
        .required("La confirmación es requerida")
        .oneOf([Yup.ref("password")], "La contraseña no coincide"),
    });

    return {
      onSubmit,
      schema,
      obj,
      isLoading,
    };
  },
};
</script>

<style>
* {
  box-sizing: border-box;
}

:root {
  --primary-color: #0071fe;
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
  width: 100%;
  border-radius: 7px;
  margin-top: 40px;
  transition: transform 0.3s ease-in-out;
  cursor: pointer;
}

.submit-btn:hover {
  transform: scale(1.1);
}
</style>
