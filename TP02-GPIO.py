import tkinter as tk
from tkinter import simpledialog, messagebox
import os

#Nome: Mateus Salles Novaes Rocha
#RA: 200581

#Variável global
GPIO = ""

#Função para selecionar o GPIO
def gpio_select():
    global GPIO
    GPIO = simpledialog.askstring("Selecionar GPIO", "Insira o número do GPIO desejado:")
    if GPIO == "":
        messagebox.showerror("Erro", "Nenhum GPIO foi selecionado!")
        exit(1)

#Função para exportar o GPIO
def gpio_export():
    if not os.path.exists(f"/sys/class/gpio/gpio{GPIO}"):
        with open("/sys/class/gpio/export", 'w') as f:
            f.write(GPIO)

#Função para configurar o GPIO
def gpio_config():
    option = simpledialog.askinteger(
        "Configurar GPIO",
        f"Escolha a configuração para o GPIO {GPIO}:\n1 - Configurar como Entrada\n2 - Configurar como Saída",
        minvalue=1, maxvalue=2)
        #Min value e Max value limita a escolha do usuário entre 1 ou 2
    if option == 1:
        with open(f"/sys/class/gpio/gpio{GPIO}/direction", 'w') as f:
            f.write("in")
        with open(f"/sys/class/gpio/gpio{GPIO}/value", 'r') as f:
            value = f.read().strip()
        messagebox.showinfo("Valor GPIO", f"O valor atual do GPIO {GPIO} é: {value}")
 
    elif option == 2:
        with open(f"/sys/class/gpio/gpio{GPIO}/direction", 'w') as f:
            f.write("out")
        state = simpledialog.askinteger(
            "Configurar estado", "Escolha o estado do GPIO:\n1 - HIGH (1)\n0 - LOW (0)", minvalue=0, maxvalue=1)
        with open(f"/sys/class/gpio/gpio{GPIO}/value", 'w') as f:
            f.write(str(state))
        messagebox.showinfo("Estado configurado", f"O estado do GPIO {GPIO} foi configurado para: {state}")
 
    else:
        messagebox.showerror("Erro", "Opção inválida.")
        exit(1)
 
# Main function
def main():
    root = tk.Tk()
    root.withdraw()  
 
    gpio_select()
    gpio_export()
    gpio_config()
 
    messagebox.showinfo("Sucesso", "Configuração do GPIO concluída com sucesso!")
    root.destroy()
 
if __name__ == "__main__":
    main()
    
        
        