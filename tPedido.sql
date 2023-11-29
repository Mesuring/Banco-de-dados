CREATE OR ALTER PROCEDURE pra.fazerPedido 
    @cpfCliente char(11), @idProd SMALLINT, @qtd_Comprada SMALLINT, @data date, @Cep char(11),
    @numCasa SMALLINT, @idFunc CHAR(3)
AS
BEGIN
    insert into pra.Pedido values (@cpfCliente, @idProd, @qtd_Comprada, @data, @Cep,@numCasa, @idFunc)
    if @@ERROR <>0
    BEGIN
        declare @Mensagem NVARCHAR
        SELECT @Mensagem = ERROR_MESSAGE()
        RAISERROR ('Erro ao incluir um Pedido: %s', @Mensagem,16,2)
    END
    else
        print('Venda realizada com sucesso!')
END



Create or alter Trigger pra.acabouProdutoAndDiminuiEstoque on pra.Pedido for insert,update as
BEGIN
    Declare @qtdEstoque int, @qtdPedida int,@idVenda int, @idProduto SMALLINT, @novoEstoque int

    SELECT @idProduto = idProd from inserted
    select @idVenda = idVenda from inserted
    select @qtdPedida = qtd_Comprada from inserted
    select @qtdEstoque = QtdEstoque from pra.produto

    if(@qtdEstoque>=@qtdPedida)
    begin
        set @novoEstoque = @qtdEstoque - @qtdPedida

        UPDATE pra.Produto set QtdEstoque = @novoEstoque where idProd = @idProduto
        print 'Estoque Atualizado'
    end
    else
        BEGIN
            delete from pra.Pedido where idVenda = @idVenda
            RAISERROR('Quantidade em estoque não disponível',15,1)
        End
END


CREATE OR ALTER VIEW pra.ValorVendas as
SELECT
    c.firNome +' '+c.meioNome +' '+c.ultNome as 'Cliente', c.CPF_Cliente, p.valorUnitario * pe.qtd_Comprada as 'valor em R$'
FROM
    (pra.Pedido as pe join pra.Produto as p on pe.idProd = p.idProd) join pra.Cliente as c on pe.CPF_Cliente = c.CPF_Cliente