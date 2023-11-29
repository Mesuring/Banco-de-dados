--Procedimentos tabelas produto

CREATE OR ALTER PROCEDURE pra.incluirProduto
    @idProd SMALLINT, @nomeProd VARCHAR(25),@qtdEstoque SMALLINT, @info text, @tipo_de_solo VARCHAR(20), @especie VARCHAR(20)
as
BEGIN
    if NOT exists (Select idProd from pra.Produto where idProd = @idProd)
        begin
            insert into pra.Produto values (@idProd, @nomeProd, @qtdEstoque, @info, @tipo_de_solo, @especie)
            if @@ERROR <>0
            BEGIN
                declare @Mensagem NVARCHAR
                SELECT @Mensagem = ERROR_MESSAGE()
                RAISERROR ('Erro ao incluir um produto: %s', @Mensagem,16,2)
            END
            else
            BEGIN
                print('Inclusão de produto realizada com sucesso!')
            END
        end
    else -- Caso houver anuncie o ERRO
        RAISERROR ('Produto já existe no banco de Dados, ARRUME!!',16,2)
END

CREATE PROCEDURE pra.excluirProduto
    @idProd SMALLINT
as
BEGIN
    if  exists (Select idProd from pra.Produto where idProd = @idProd)
        begin
            Delete from pra.Produto where idProd = @idProd
            if @@ERROR <>0
            BEGIN
                declare @Mensagem NVARCHAR
                SELECT @Mensagem = ERROR_MESSAGE()
                RAISERROR ('Erro ao excluir um produto: %s', @Mensagem,16,2)
            END
        end
    else -- Caso houver anuncie o ERRO
        RAISERROR ('Produto selecionado não existe no banco de Dados, ARRUME!!',16,2)
END


CREATE OR ALTER VIEW pra.aComprar as
Select
    nomeProd as 'Produto', idProd as 'ID', qtdEstoque as 'Quantidade em Estoque', f.CNPJ as 'Fornecedor'
from
pra.Produto as p JOIN pra.Fornecedor as f on p.idProd = f.materialFornecido
where
    qtdEstoque <5

