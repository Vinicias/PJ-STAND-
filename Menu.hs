module Menu where 
import System.IO
import Data.Char
import Data.Time 
import Factura
import Automovel
import FicheirosFactura

carregarFactura:: IO()
carregarFactura = do
            file <- openFile  "Ficheiros /factura_cliente.txt" ReadMode 
            dados <- hGetContents file
            let factura = read (dados) :: Facturas 
            showAllfactura factura
            hClose file


carregar :: IO()
carregar = do
            file <- openFile  "Ficheiros /factura_cliente.txt" ReadMode 
            dados <- hGetContents file
            let factura = read (dados) :: Facturas 
            menuPrincipal (factura)
            hClose file


findFacturaCod  :: Facturas ->IO()
findFacturaCod  factura = do 
        putStrLn "Informe o Codigo da Factura: "
        cod <- readLn :: IO Int  
        searchFact cod factura

findFacturaDay :: Facturas -> IO() 
findFacturaDay  factura = do 
        putStrLn "Informe o dia que deseja "
        d <- getLine 
        facDay d factura


--Menu para a funcão compra --

menuCompra :: Facturas->IO()
menuCompra facturas = do 
        let codfactura = (length facturas )+1
        putStrLn "============== Menu Compra  PJ-STAND============= "
        putStrLn "Informe o nome : "
        nome <-getLine 
        putStrLn "Informe o numero de Telefone: "
        phone <-readLn :: IO Int 
        putStrLn "Informe o codigo(s)do Automovel: "
        cod <- readLn :: IO Int 
        let valor = findPrice cod automoveis
        putStrLn ("Preço: "++show (valor)++" AKZ")
        putStrLn "Informe a quantidade: "
        qtd <- readLn :: IO Float
        let  total = ((findPrice cod automoveis)*qtd)
        putStrLn ("Preço a pagar : "++show (total)++" AKZ")
        valorPago <- readLn :: IO Float
        let troco = (valorPago - total)
        if(valorPago >=  total) then do {
        variavel <-getCurrentTime; putStrLn ("Troco: "++show(troco)++"    Data Compra :"++(take 19 (show(variavel)))++"  Codigo Factura:"++show(codfactura));
        inserir (facturas++facturaCliente (codfactura,nome,phone,cod,qtd,valor,valorPago,troco,(take 19(show(variavel)))));
                
        }
               else do { putStrLn " Valor Insuficiente"; menuPrincipal facturas }          

--Menu para a função ver preço--
menuVerpreco :: IO()
menuVerpreco = do  
        putStrLn "=================Ver-Preçario==============="
        putStrLn "Informe o codigo do Automovel: "
        codigo <- readLn :: IO Int 
        let valor = findPrice codigo automoveis;
        putStrLn ("Preço: "++show (valor)++" AKZ")

menuPrincipal ::Facturas->IO()
menuPrincipal  factura = do 
        
    putStrLn ("=====================================================================")
    putStrLn ("|                1-Ver Precario                                      |") 
    putStrLn ("|                2-Listar Automoveis                                 |")
    putStrLn ("|                3-Efectuar Compra                                   |")
    putStrLn ("|                4-Consultar Factura                                 |")
    putStrLn ("|                5-Ver Factura Diário                                |")
    putStrLn ("|                6-Ver Todas Facturas                                |")
    putStrLn ("|                7-Mostra as informacoes do Automovel mais vendido   |")
    putStrLn ("|                8-Sair                                              |")
    putStr "       Digite a opção desejada: "
    opcao <- readLn
    putStrLn ""
    
    case opcao of
         1 -> do
                menuVerpreco
                putStrLn "1-Para voltar ao Menu Principal \n0-Para ver o preço novamente: "
                op <- readLn :: IO Int 
                if op == 1 then menuPrincipal factura else menuVerpreco 
         2 -> do putStrLn "============Listar Automoveis============\n\n" 
                 putStrLn "Nome     Codigo    Preço   Categoria      Marca    Tipo "
                 listaAutomoveis automoveis
                 putStrLn "Precione 1 para voltar ao menuPrincipal:  "
                 op <- readLn :: IO Int 
                 if op == 1 then menuPrincipal factura  else menuPrincipal factura                      
         3 -> do putStrLn "\n\n\n\n"
                 menuCompra (factura)
                 putStrLn "1-Para voltar ao Menu Principal \n2-Para efectuar uma outra compra:  "
                 opcao <- readLn :: IO Int 
                 if(opcao == 1 ) then menuPrincipal factura else carregar 
        
         4 -> do putStrLn "Consultar Factura"
                 findFacturaCod  factura   
                 putStrLn "1->para consultar novamente \n2->para voltar ao menu Principal "
                 op <- readLn :: IO Int 
                 if(op== 1) then findFacturaCod  factura else if (op==2) then menuPrincipal factura else do {
                  putStrLn "Opção Invalida "; findFacturaCod  factura;
                 }
         5 -> do putStrLn "Ver Factura Diário"
                 findFacturaDay factura 
                 putStrLn "1-> para Consultar Factura Diaria Novamente\n2->Paravoltar ao menu Principal"
                 op <- readLn :: IO Int 
                 if(op == 1 ) then findFacturaDay factura else if (op== 2) then   menuPrincipal factura else do {
                        putStrLn "Opção Invalida "; 
                        menuPrincipal factura;
                 }
         6 -> do putStrLn "Ver Todas Facturas"
                 putStrLn "Codigo Cliente          Phone       CodProduto    Qtd PreçoProd  Pago Troco Data   "
                 carregarFactura
         7 -> do putStrLn "Mostra as informacoes do Automovel mais vendido"
         8 -> do putStrLn "Terminando o Programa ...Volte Sempre "
         _ -> do{ putStrLn "Opcão Invalida "; menuPrincipal factura}
             

         

