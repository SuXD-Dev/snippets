/** Useful JavaScript code snippets. */

// --- Array Utils ---

const unique = (arr) => [...new Set(arr)];

const chunk = (arr, size) =>
  Array.from({ length: Math.ceil(arr.length / size) }, (_, i) =>
    arr.slice(i * size, i * size + size)
  );

const shuffle = (arr) => {
  const a = [...arr];
  for (let i = a.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [a[i], a[j]] = [a[j], a[i]];
  }
  return a;
};

const groupBy = (arr, key) =>
  arr.reduce((acc, item) => {
    (acc[item[key]] = acc[item[key]] || []).push(item);
    return acc;
  }, {});

// --- Object Utils ---

const deepClone = (obj) => JSON.parse(JSON.stringify(obj));

const pick = (obj, keys) =>
  keys.reduce((acc, key) => { if (key in obj) acc[key] = obj[key]; return acc; }, {});

const omit = (obj, keys) =>
  Object.fromEntries(Object.entries(obj).filter(([k]) => !keys.includes(k)));

// --- String Utils ---

const truncate = (str, len) => str.length > len ? str.slice(0, len - 3) + '...' : str;

const slugify = (str) => str.toLowerCase().trim().replace(/[^\w\s-]/g, '').replace(/[-\s]+/g, '-');

const capitalize = (str) => str.charAt(0).toUpperCase() + str.slice(1);

const isEmail = (str) => /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(str);

// --- Function Utils ---

const debounce = (fn, ms) => {
  let timer;
  return (...args) => {
    clearTimeout(timer);
    timer = setTimeout(() => fn(...args), ms);
  };
};

const throttle = (fn, ms) => {
  let last = 0;
  return (...args) => {
    const now = Date.now();
    if (now - last >= ms) { last = now; fn(...args); }
  };
};

const once = (fn) => {
  let called = false;
  return (...args) => { if (!called) { called = true; return fn(...args); } };
};

// --- Async ---

const sleep = (ms) => new Promise(resolve => setTimeout(resolve, ms));

const retry = async (fn, retries = 3, delay = 1000) => {
  for (let i = 0; i < retries; i++) {
    try { return await fn(); } catch (e) { if (i === retries - 1) throw; await sleep(delay * 2 ** i); }
  }
};

const promiseAllSettled = async (promises) => {
  const results = await Promise.allSettled(promises);
  return { fulfilled: results.filter(r => r.status === 'fulfilled').map(r => r.value),
           rejected: results.filter(r => r.status === 'rejected').map(r => r.reason) };
};

// --- DOM ---

const $ = (sel) => document.querySelector(sel);
const $$ = (sel) => [...document.querySelectorAll(sel)];

const addClass = (el, cls) => el.classList.add(cls);
const removeClass = (el, cls) => el.classList.remove(cls);
const toggleClass = (el, cls) => el.classList.toggle(cls);

// Tests
console.log('Unique:', unique([1, 2, 2, 3, 3, 4]));
console.log('Chunk:', chunk([1, 2, 3, 4, 5], 2));
console.log('Slugify:', slugify('Hello World!'));
console.log('Is email:', isEmail('test@example.com'));
