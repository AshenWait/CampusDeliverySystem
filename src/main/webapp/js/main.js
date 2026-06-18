/**
 * 校园快递代取与寄件管理系统 - 主脚本
 */

/**
 * AJAX 检查用户名是否存在（注册页使用）
 */
function checkUsername() {
    var username = document.getElementById('username').value;
    var tip = document.getElementById('usernameTip');

    if (!username || username.trim() === '') {
        tip.innerHTML = '';
        tip.className = 'inline-tip';
        return;
    }

    var xhr = new XMLHttpRequest();
    xhr.open('POST', 'user?action=checkUsername&username=' + encodeURIComponent(username), true);
    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4 && xhr.status === 200) {
            var result = xhr.responseText.trim();
            if (result === 'exists') {
                tip.innerHTML = '× 用户名已存在';
                tip.className = 'inline-tip error';
            } else if (result === 'available') {
                tip.innerHTML = '√ 用户名可以使用';
                tip.className = 'inline-tip ok';
            } else {
                tip.innerHTML = '';
                tip.className = 'inline-tip';
            }
        }
    };
    xhr.send();
}

/**
 * AJAX 异步接单（代取员在订单大厅使用）
 */
function receiveOrder(orderId) {
    if (!confirm('确定要接这个订单吗？')) return;

    var xhr = new XMLHttpRequest();
    xhr.open('POST', 'order?action=receive&orderId=' + orderId, true);
    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4 && xhr.status === 200) {
            var result = xhr.responseText.trim();
            if (result === 'success') {
                alert('接单成功！');
                location.reload();
            } else {
                alert('接单失败，该订单可能已被其他人接走。');
            }
        }
    };
    xhr.send();
}

/**
 * AJAX 管理员删除订单
 */
function deleteOrder(orderId) {
    if (!confirm('确定要删除这个订单吗？如存在评价也会一并删除。此操作不可恢复。')) return;

    var xhr = new XMLHttpRequest();
    xhr.open('POST', 'order?action=delete&orderId=' + orderId, true);
    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4 && xhr.status === 200) {
            var result = xhr.responseText.trim();
            if (result === 'success') {
                alert('删除成功！');
                location.reload();
            } else if (result.startsWith('fail:')) {
                alert(result.substring(5));
            } else {
                alert('删除失败，请重试。');
            }
        }
    };
    xhr.send();
}

/**
 * AJAX 管理员删除用户
 */
function deleteUser(userId) {
    if (!confirm('确定要删除这个用户吗？此操作不可恢复。')) return;

    var xhr = new XMLHttpRequest();
    xhr.open('POST', 'admin?action=deleteUser&userId=' + userId, true);
    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4 && xhr.status === 200) {
            var result = xhr.responseText.trim();
            if (result === 'success') {
                alert('删除成功！');
                location.reload();
            } else if (result.startsWith('fail:')) {
                alert(result.substring(5));
            } else {
                alert('删除失败，请重试。');
            }
        }
    };
    xhr.send();
}

/**
 * AJAX 更新订单状态
 */
function updateOrderStatus(orderId, status) {
    var statusNames = {
        '待接单': '待接单',
        '已接单': '已接单',
        '配送中': '配送中',
        '已完成': '已完成',
        '已取消': '已取消'
    };

    if (!confirm('确定将订单状态修改为 "' + (statusNames[status] || status) + '" 吗？')) return;

    var xhr = new XMLHttpRequest();
    xhr.open('POST', 'order?action=updateStatus&orderId=' + orderId + '&status=' + encodeURIComponent(status), true);
    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4 && xhr.status === 200) {
            location.reload();
        }
    };
    xhr.send();
}

/**
 * 取消订单确认（普通跳转）
 */
function cancelOrder(orderId) {
    if (!confirm('确定要取消这个订单吗？')) return;
    window.location.href = 'order?action=cancel&orderId=' + orderId;
}

/**
 * 确认删除公告（普通跳转）
 */
function deleteNotice(id) {
    if (!confirm('确定要删除这条公告吗？')) return;
    window.location.href = 'notice?action=delete&id=' + id;
}
