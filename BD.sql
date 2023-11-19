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



--Criação dos Stored Procedures
--INSERIR
--Recebe como parametro os valores para incluir o funcionário
CREATE or ALTER PROCEDURE pra.inserindoFuncionario
    @idFunc char(3), @fFirNome varchar(15),@fMeioNome char(1),@fUltNome varchar(15),
    @dataNacimento date,@salario int, @nivelPrestigio tinyint
as 
BEGIN   --Caso não exista um funcionário com o id apresentado inserir
    if NOT exists (Select idFunc from pra.Funcionario where idFunc = @idFunc)
        begin
            insert into pra.Funcionario values (@idfunc, @fFirNome,@fMeioNome,@fUltNome,@dataNacimento,@salario,@nivelPrestigio)
            if @@ERROR <>0
            BEGIN
                declare @Mensagem NVARCHAR
                SELECT @Mensagem = ERROR_MESSAGE()
                RAISERROR ('Erro ao incluir um empregado: %s', @Mensagem,16,2)
            END
        end
    else -- Caso houver anuncie o ERRO
        RAISERROR ('id de Funcionário já existe no banco de Dados, ARRUME!!',16,2)
END
--EXCLUIR
CREATE or ALTER PROCEDURE pra.excluirFuncionario
    @idFunc char(3)
as 
BEGIN   --Caso  exista um funcionário com o id apresentado excluir
    if  exists (Select idFunc from pra.Funcionario where idFunc = @idFunc)
        begin
            DELETE From pra.funcionario WHERE idFunc = @idFunc
            if @@ERROR <>0
            BEGIN
                declare @Mensagem NVARCHAR
                SELECT @Mensagem = ERROR_MESSAGE()
                RAISERROR ('Erro ao excluir um empregado: %s', @Mensagem,16,2)
            END
        end
    else -- Caso houver anuncie o ERRO
        RAISERROR ('id de Funcionário não existe no banco de Dados, ARRUME!!',16,2)
END 

CREATE OR ALTER PROCEDURE pra.alteraSalario
    @idFunc char(3), @salario int
AS
BEGIN
    if exists (select idFunc from pra.Funcionario WHERE idFunc =@idFunc)
    begin
        update pra.funcionario set salario = @salario where idFunc = @idFunc
            if @@ERROR <>0
                BEGIN
                    declare @Mensagem NVARCHAR
                    SELECT @Mensagem = ERROR_MESSAGE()
                    RAISERROR ('Erro ao alterar salario:  %s', @Mensagem,16,2)
                END
    end
    else
        RAISERROR ('id de Funcionário não existe no banco de Dados, ARRUME!!',16,2)
END