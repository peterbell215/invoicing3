import axios from 'axios'

import 'bootstrap'
import * as mdb from 'mdb-ui-kit'; // lib
window.mdb = mdb;

import { createInertiaApp } from '@inertiajs/svelte'

import Layout from '../components/Layouts/Layout.svelte'

const pages = import.meta.glob('../pages/**/*.svelte')

const csrfToken = document.querySelector('meta[name=csrf-token]').content
axios.defaults.headers.common['X-CSRF-Token'] = csrfToken

createInertiaApp({
    resolve: async name => {
        const page = await pages[`../pages/${name}.svelte`]()
        return Object.assign({layout: Layout}, page)
    },
    setup({ el, App, props }) {
        new App({ target: el, props })
    },
})
