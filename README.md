```markdown
# 💰 CryptBank – Smart Contract Ethereum

Un contrato inteligente en Solidity para almacenar y retirar Ether de forma segura. Compatible con múltiples usuarios y desarrollado bajo las reglas de la licencia GPL-3.0.

---

## 📜 Licencia

```
SPDX-License-Identifier: GPL-3.0
```

---

## ⚙️ Requisitos

- Solidity `^0.8.30`
- Entorno compatible con EVM (Ethereum Virtual Machine)
- IDE recomendado: [Remix](https://remix.ethereum.org/) o entornos como Hardhat o Foundry

---

## 🧠 Descripción del contrato

`CryptBank` es un contrato inteligente que permite a múltiples usuarios depositar y retirar Ether, con límites de depósito configurables por el propietario. Los fondos están ligados a cada dirección de usuario y sólo pueden ser retirados por el titular de la cuenta.

---

## 🛠️ Funcionalidades

### 1. **Depósito de Ether**
```solidity
function deposit() external payable
```
- Permite a cualquier usuario depositar Ether en el contrato.
- Verificaciones de seguridad:
  - El valor enviado (`msg.value`) debe ser mayor que cero.
  - El nuevo saldo del usuario no puede exceder el `maxBalance` definido por el propietario.

### 2. **Retirada de Ether**
```solidity
function withdraw(uint256 amount_) external
```
- Permite a los usuarios retirar su propio Ether almacenado.
- Verificaciones de seguridad:
  - Solo se puede retirar si el usuario tiene suficiente saldo.
  - Se previene el retiro de `0` ETH.
  - El uso de `call` en lugar de `transfer` o `send` mejora la compatibilidad con contratos que reciben fondos.

### 3. **Configuración de balance máximo (solo propietario)**
```solidity
function newMaxBalance(uint256 newMaxBalance_) public onlyOwner
```
- Permite al propietario actualizar el límite máximo de Ether que puede tener cada usuario.
- Utiliza el modificador `onlyOwner` para restringir el acceso.

---

## 🧾 Eventos

- `Deposit(address user_, uint256 amount_)` – Emitido cuando un usuario deposita Ether.
- `Withdraw(address user_, uint256 amount_)` – Emitido cuando un usuario realiza una retirada.

---

## 🔐 Seguridad y Comportamiento

### ✅ Buenas prácticas implementadas

- **Control de acceso**:  
  El modificador `onlyOwner` (aunque incorrectamente implementado, ver nota abajo) restringe funciones administrativas.

- **Límites de depósito**:  
  Cada usuario tiene un límite máximo definido para evitar grandes acumulaciones de fondos en una sola cuenta.

- **Gestión segura de fondos**:  
  El retiro usa `call` para permitir compatibilidad con wallets y contratos que puedan requerir más gas del que permite `transfer`.

- **Protección contra "overflows"**:  
  Uso de Solidity 0.8.x que incluye protecciones integradas contra desbordamientos numéricos.

---

## ⚠️ Problemas y recomendaciones

### ❗️ Modificador `onlyOwner` mal implementado
```solidity
require(msg.sender != owner, "Only owner can call this function");
```
- **Error lógico**: Esta línea permite a **cualquier usuario excepto al propietario** llamar la función.
- **Solución correcta**:
```solidity
require(msg.sender == owner, "Only owner can call this function");
```

### 🚫 No hay control de pausado del contrato
- Podrías añadir un mecanismo de `pausable` para emergencias (usando OpenZeppelin o manualmente).

### ⚠️ Sin protección contra ataques de reentrancia
- Aunque el uso de `call` es válido, se recomienda implementar el patrón _checks-effects-interactions_ o usar `ReentrancyGuard`.

### 🔐 No hay fallback ni receive function
- El contrato sólo acepta Ether mediante `deposit()`. Si un usuario envía Ether directamente, se perderá (reversión).
- **Solución recomendada**:
```solidity
receive() external payable {
    deposit();
}
```

---

## 🧪 Ejemplo de uso (Remix)

1. Despliega el contrato con un `maxBalance`, por ejemplo: `1000000000000000000` (1 ETH).
2. Cambia a otra cuenta y llama a `deposit()` con un valor en ETH.
3. Usa `balances(address)` para ver tu saldo.
4. Llama a `withdraw(cantidad)` para recuperar tus fondos.
5. Desde la cuenta `owner`, llama a `newMaxBalance()` para actualizar el límite.

---

## 🧱 Estructura del contrato

```
CryptBank
├── Variables públicas: owner, maxBalance, balances
├── Eventos: Deposit, Withdraw
├── Modificador: onlyOwner
├── Constructor: establece el owner y el balance máximo
├── Funciones:
│   ├── deposit()
│   ├── withdraw(uint256)
│   └── newMaxBalance(uint256)
```

---

## 🧩 Futuras mejoras (sugerencias)

- Añadir interfaz gráfica (frontend) con React + Web3.js / Ethers.js
- Sistema de recompensas por depósitos prolongados (staking)
- Añadir `getUsers()` si se desea visualizar todas las cuentas activas (requeriría estructura adicional)
- Soporte para tokens ERC20 (versión multimoneda)

---

## 👨‍💻 Autor

> Proyecto de contrato inteligente desarrollado con fines educativos.  
> Cualquier contribución o mejora es bienvenida.
```
