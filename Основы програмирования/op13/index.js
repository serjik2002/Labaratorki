//Валидация имени
function nameValidate() {
    var name = '';
    name = document.getElementById("name").value;
    if (name.length == 0) {
       alert("Поле должно быть заполненым!")
    }
    
}
//Валидация фамилии
function surnameValidate(){
    var surname = '';
    surname = document.getElementById("surname").value;
    if (surname.length == 0) {
       alert("Поле должно быть заполненым!"); 
    }
}

//Валидация телефона
function numberValidate() {
    var number = '';
    number = document.getElementById("number").value;
    if (number.length == 0) {
       alert("Поле должно быть заполненым!"); 
    }
    else{
        let regex = /^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$/;
        if (!regex.test(number)) {
            alert('Не правильный номер телефона');
        }
    }
    
}
//Валидация почты
function emailValidate() {
    var email = '';
    email = document.getElementById("email").value;
    if (email.length == 0) {
        alert("Поле должно быть заполненым!"); 
    }else{
        let regex2 = /^([a-z0-9_-]+\.)*[a-z0-9_-]+@[a-z0-9_-]+(\.[a-z0-9_-]+)*\.[a-z]{2,6}$/;
        if (!regex2.test(email)) {
           alert('Не правильный email')  
        }
    }
    
}
//валидация пароля
function passwordValidate() {
    var password = '';
    password = document.getElementById('psw').value;
    if(password.length == 0){
        alert("Поле должно быть заполненым!")
    }
}

//Валидация повторения пароля
function passwordRepeatValidate() {
    var pass1 = document.getElementById('psw');
    var pass2 = document.getElementById('psw_repeat');
    if(pass1.value !== pass2.value)
    {
        alert('Пароли не совпадают!')
    }
}

//валидация формы
function formValidate() {
    nameValidate();
    surnameValidate();
    numberValidate();
    emailValidate();
    passwordValidate();
 }

 //отчистка формы
 function cleanForm(){
    document.getElementById('form').reset();
 }