import { createWebHistory, createRouter } from "vue-router";
import Home from "@/components/Home.vue";
import Counter from "@/components/Counter.vue";
import FetchData from "@/components/FetchData.vue";
import ResetearPassword from "@/components/ResetearPassword.vue";
import ConfirmarCuenta from "@/components/ConfirmarCuenta.vue";

const routes = [
    {
        path: "/",
        name: "Home",
        component: Home,
    },
    {
        path: "/Counter",
        name: "Counter",
        component: Counter,
    },
    {
        path: "/FetchData",
        name: "FetchData",
        component: FetchData,
    
    },
    {
        path: "/ResetearPassword/:email/:token*",
        name: "ResetearPassword",
        component: ResetearPassword,
    },
    {
        path: "/ConfirmarCuenta/:email/:token*",
        name: "ConfirmarCuenta",
        component: ConfirmarCuenta,
    }
];

const router = createRouter({
    history: createWebHistory(),
    routes,
});

export default router;