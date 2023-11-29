--Procedimento da tabela de Fornecedor

Create or alter procedure pra.insereFornecedor
    @CNPJ char(14), @devemos bit, @valorDivida int, @materialFornecido SMALLINT
AS
BEGIN
    if NOT exists (Select CNPJ from pra.Fornecedor where CNPJ = @CNPJ)
    begin
        insert into pra.Fornecedor values (@CNPJ, @devemos, @valorDivida, @materialFornecido)
        if @@ERROR <>0
        BEGIN
            declare @Mensagem NVARCHAR
            SELECT @Mensagem = ERROR_MESSAGE()
            RAISERROR ('Erro ao incluir um fornecedor: %s', @Mensagem,16,2)
        END
        else
        BEGIN
            print('Cadastro de fornecedor feito com sucesso!')
        END
    end
else -- Caso houver anuncie o ERRO
    RAISERROR ('Fornecedor já existe no banco de Dados, ARRUME!!',16,2)
END



CREATE OR ALTER PROCEDURE pra.excluirFornecedor
    @CNPJ char(14)
AS
BEGIN
     if  exists (Select CNPJ from pra.Fornecedor where CNPJ = @CNPJ)
        begin
            Delete from pra.Fornecedor where CNPJ = @CNPJ
            if @@ERROR <>0
            BEGIN
                declare @Mensagem NVARCHAR
                SELECT @Mensagem = ERROR_MESSAGE()
                RAISERROR ('Erro ao excluir um Fornecedor: %s', @Mensagem,16,2)
            END
        end
    else -- Caso houver anuncie o ERRO
        RAISERROR ('Fornecedor não existe no banco de Dados, ARRUME!!',16,2)
END



CREATE OR ALTER VIEW pra.forneceOQue AS
SELECT
    f.CNPJ as 'Empresa', p.nomeProd as 'Produto', p.idProd as 'ID'
FROM
pra.Produto as p join pra.Fornecedor as f on f.materialFornecido = p.idProd



CREATE OR ALTER VIEW pra.quemDevemos AS
Select
    f.CNPJ as 'Empresa',f.valorDivida as 'R$', p.nomeProd as 'Produto', f.materialFornecido  as 'ID'
from
    pra.Produto as p JOIN pra.Fornecedor as f on p.idProd = f.materialFornecido
where
devemos = 1