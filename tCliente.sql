--Procedimentos da tabela de CLiente

CREATE OR ALTER PROCEDURE pra.incluirCliente
    @CPF_Cliente char(11), @firNome varchar(15),@meioNome char(1),@ultNome varchar(15),@Email VARCHAR(30),
    @CEP char(8), @numCasa SMALLINT, @Aniversario date, @senha varchar(20)
as
BEGIN
    if NOT exists (Select CPF_Cliente from pra.Cliente where CPF_Cliente = @CPF_Cliente)
        begin
            insert into pra.Cliente values (@CPF_Cliente, @firNome, @meioNome, @ultNome, @Email,@CEP, @numCasa, @Aniversario, @senha)
            if @@ERROR <>0
            BEGIN
                declare @Mensagem NVARCHAR
                SELECT @Mensagem = ERROR_MESSAGE()
                RAISERROR ('Erro ao incluir um Cliente: %s', @Mensagem,16,2)
            END
        end
    else -- Caso houver anuncie o ERRO
        RAISERROR ('Cliente já existe no banco de Dados, ARRUME!!',16,2)
END


CREATE OR ALTER PROCEDURE pra.excluirCliente
    @CPF_Cliente char(11)
as
BEGIN
    if  exists (Select CPF_Cliente from pra.Cliente where CPF_Cliente = @CPF_Cliente)
        begin
            Delete from pra.cliente where CPF_Cliente = @CPF_Cliente
            if @@ERROR <>0
            BEGIN
                declare @Mensagem NVARCHAR
                SELECT @Mensagem = ERROR_MESSAGE()
                RAISERROR ('Erro ao excluir um Cliente: %s', @Mensagem,16,2)
            END
        end
    else -- Caso houver anuncie o ERRO
        RAISERROR ('CPF não existe no banco de Dados, ARRUME!!',16,2)
END


CREATE OR ALTER TRIGGER pra.clienteMenorIdade on pra.cliente for insert,UPDATE AS
BEGIN
    declare @idade real, @CPF_Cliente char(11),@data date
    select @CPF_Cliente = CPF_Cliente, @data = Aniversario from inserted
    set @idade = DATEDIFF(Year,@data, GetDate())
    if @idade<=14
    begin
        Delete from pra.cliente where CPF_Cliente = @CPF_Cliente
        RAISERROR ('ERRO! Cliente menor de idade, não pode ser incluido',16,1)
    end
    else
        print ('INCLUSÃO REALIZADA COM SUCESSO')
END


CREATE OR ALTER VIEW pra.aniversarioClienteHoje as
 Select
    firNome +' '+meioNome +' '+ultNome as 'Cliente', CPF_Cliente, Email
from
    pra.cliente
where
Datename(MONTH,Aniversario) = DATENAME(month, GetDate()) and
Datename(DAY,Aniversario) = DATENAME(DAY, GetDate())


CREATE OR ALTER VIEW pra.verificaLogin as 
Select
    *
from
pra.cliente
