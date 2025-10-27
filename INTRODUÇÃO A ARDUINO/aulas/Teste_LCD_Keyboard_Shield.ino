/*
  Testando o teclado do SHIELD DISPLAY 16 X 2 KEYPAD COM TECLADO
*/

#include <LiquidCrystal.h> //Inclui a biblioteca

const int rs = 8, en = 9, d4 = 4, d5 = 5, d6 = 6, d7 = 7;//Pinos para ligar o display
LiquidCrystal lcd(rs, en, d4, d5, d6, d7);//Define os pinos que serão usados para ligar o display

void setup() {

  lcd.begin(16, 2);//Define o número de colunas e linhas do display
  lcd.setCursor(0, 0);//Define o cursor para a coluna 0, linha 0
  lcd.print("      IFSC");
  lcd.setCursor(0, 1);//Define o cursor para a coluna 0, linha 1
  lcd.print("    LGP18802");
  Serial.begin(9600);
}

//Função para botão select
void select() {
  lcd.clear(); //limpa o display
  lcd.setCursor(0, 0);//Define o cursor para a coluna 0, linha 0
  lcd.print("APERTOU O BOTAO");
  lcd.setCursor(0, 1);//Define o cursor para a coluna 0, linha 1
  lcd.print("     SELECT     ");
}

//Função para botão left
void left() {
  lcd.clear(); //limpa o display
  lcd.setCursor(0, 0);//Define o cursor para a coluna 0, linha 0
  lcd.print("APERTOU O BOTAO");
  lcd.setCursor(0, 1);//Define o cursor para a coluna 0, linha 1
  lcd.print("      LEFT      ");
}

//Função para botão up
void up() {
  lcd.clear();
  lcd.setCursor(0, 0);//Define o cursor para a coluna 0, linha 0
  lcd.print("APERTOU O BOTAO");
  lcd.setCursor(0, 1);//Define o cursor para a coluna 0, linha 1
  lcd.print("       UP       ");
}

//Função para botão down
void down() {
  lcd.clear();
  lcd.setCursor(0, 0);//Define o cursor para a coluna 0, linha 0
  lcd.print("APERTOU O BOTAO");
  lcd.setCursor(0, 1);//Define o cursor para a coluna 0, linha 1
  lcd.print("      DOWN      ");
}

//Função para botão right
void right() {
  lcd.clear();
  lcd.setCursor(0, 0);//Define o cursor para a coluna 0, linha 0
  lcd.print("APERTOU O BOTAO");
  lcd.setCursor(0, 1);//Define o cursor para a coluna 0, linha 1
  lcd.print("     RIGHT      ");
}

void loop() {
  Serial.println(analogRead(0));//Exibe a leitura do pino analógico A0 no monitor serial
  //Esse é o pino onde estão ligados os 5 botões (Select, Up, Down, Right e Left)
  //Dessa forma, verifica-se qual dos 5 botões foi pressionado
  delay(100);

  //Se a leitura for menor que 80 chama a função right, pois esse botão foi pressionado
  if ((analogRead(0)) < 80) { 
    right();
  }

  //Se a leitura for menor que 200 chama a função up, pois esse botão foi pressionado
  else if ((analogRead(0)) < 200) {
    up();
  }

  //Se a leitura for menor que 400 chama a função down, pois esse botão foi pressionado
  else if ((analogRead(0)) < 400) {
    down();
  }

  //Se a leitura for menor que 600 chama a função left, pois esse botão foi pressionado
  else if ((analogRead(0)) < 600) {
    left();
  }

  //Se a leitura for menor que 800 chama a função left, pois esse botão foi pressionado
  else if ((analogRead(0)) < 800) {
    select();
  }
}
