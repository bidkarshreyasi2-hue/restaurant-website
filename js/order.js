const MENU = [
  { id: 1, name: "Paneer Tikka", price: 220 },
  { id: 2, name: "Chicken 65", price: 260 },
  { id: 3, name: "Saoji Chicken", price: 320 },
  { id: 4, name: "Saoji Mutton", price: 420 },
  { id: 5, name: "Dal Tadka", price: 170 },
  { id: 6, name: "Paneer Butter Masala", price: 240 },
  { id: 7, name: "Butter Roti", price: 25 },
  { id: 8, name: "Jeera Rice", price: 130 },
  { id: 9, name: "Gulab Jamun", price: 90 },
  { id: 10, name: "Orange Lassi", price: 110 }
];
const cart = {};
const $ = (id) => document.getElementById(id);

function renderItems() {
  $("items").innerHTML = MENU.map(m => `
    <div class="item"><div><strong>${m.name}</strong><br><span class="price">₹${m.price}</span></div>
    <div class="qty">
      <button aria-label="Remove one ${m.name}" data-id="${m.id}" data-d="-1">−</button>
      <span id="q${m.id}">0</span>
      <button aria-label="Add one ${m.name}" data-id="${m.id}" data-d="1">+</button>
    </div></div>`).join("");
}

function renderCart() {
  let total = 0, rows = "";
  MENU.forEach(m => {
    const q = cart[m.id] || 0;
    $("q" + m.id).textContent = q;
    if (q) { total += q * m.price; rows += `<li><span>${q} × ${m.name}</span><span>₹${q * m.price}</span></li>`; }
  });
  $("cart-list").innerHTML = rows || "<li>Nothing added yet. Pick a dish to start.</li>";
  $("total").textContent = "₹" + total;
  $("place").disabled = total === 0;
}

$("items").addEventListener("click", (e) => {
  const b = e.target.closest("button"); if (!b) return;
  const id = b.dataset.id;
  cart[id] = Math.max(0, (cart[id] || 0) + Number(b.dataset.d));
  renderCart();
});

$("place").addEventListener("click", () => {
  const name = $("name").value.trim(), phone = $("phone").value.trim();
  const msg = $("msg");
  msg.style.display = "block";
  if (!name || !/^\d{10}$/.test(phone)) {
    msg.style.background = "#c2371f";
    msg.textContent = "Enter your name and a 10-digit phone number to place the order.";
    return;
  }
  msg.style.background = "#1d5a43";
  msg.textContent = `Thank you, ${name}. Your order is placed and will be ready in about 30 minutes.`;
  Object.keys(cart).forEach(k => delete cart[k]);
  renderCart();
});

renderItems(); renderCart();
