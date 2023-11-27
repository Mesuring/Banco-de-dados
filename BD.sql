--INDICES:


--Criando Indice para CEP já, por ser a forma de localização da rua e bairo é eficiente ter para CEP:

CREATE INDEX clienteCEP
on pra.Pedido (CPF_Cliente)

--Criando Indice para numCasa já que é a localização exata combinada com CEP:

CREATE INDEX clienteNumCasa
on pra.pedido (numCasa)



--Criação dos TRIGGERS:


--Criando Trigger para bloquear uma compra de um produto <= 5 no estoque, já que esses 5 são de mostruário e só podem ser vendidos na loja física
Create or alter Trigger pra.acabouProduto on pra.pedido for insert,update as
BEGIN
    Declare @qtdEstoque int, @qtdPedida int
    select @qtdPedida = qtd_Comprada from inserted
    select @qtdEstoque = QtdEstoque from pra.produto

    if(@qtdEstoque<=5 or @qtdEstoque<@qtdPedida)
    begin
        RAISERROR('Quantidade em estoque não disponível',15,1)
    end
END


--Criação das Views


CREATE VIEW pra.contaVendas
AS
select
f.fFirNome + ' '+ f.fUltNome as 'Funcinário', COUNT(p.idVenda)  as '#Vendas'
from
(pra.Funcionario as f join pra.Pedido as p on f.idFunc = p.idFunc)
GROUP BY	
f.fFirNome,f.fUltNome,p.idVenda




CREATE VIEW pra.quantasVendasProdutoX
AS
    SELECT
        f.fFirNome+' '+f.fUltNome as 'Funcionário', COUNT(*) as 'Vendas'
    from
    pra.Pedido as P join pra.Funcionario as F on F.idFunc = P.idFunc
    WHERE
        p.idVenda =@idPr



