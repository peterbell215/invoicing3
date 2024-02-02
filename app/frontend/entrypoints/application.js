import 'bootstrap'
import * as mdb from 'mdb-ui-kit'; // lib
window.mdb = mdb;

import { createInertiaApp } from '@inertiajs/svelte';
import Layout from '../components/Layouts/Layout.svelte';

const pages = import.meta.glob('../pages/**/*.svelte', { eager: true });

createInertiaApp({
    resolve: name => {
        const page =  pages[`../pages/${name}.svelte`]
        return { default: page.default, layout: page.layout || Layout }
    },
    setup({ el, App, props }) {
        new App({ target: el, props })
    },
});
