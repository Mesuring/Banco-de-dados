-- Procedimentos da tabela de Funcionário

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


CREATE OR ALTER TRIGGER pra.funciMenorDeIdade on pra.funcionario for insert,UPDATE AS
BEGIN
    declare @idFunc char(3), @data date, @idade real
    select @idFunc = idFunc, @data = dataNacimento from Inserted
    set @idade = DATEDIFF(Year,@data, GetDate())
    if @idade<18
    begin
        RAISERROR('Empregado precisa ter 18 anos ou mais!', 10,1)
    end
    else
        print ('INCLUSÃO REALIZADA COM SUCESSO')
END 



CREATE OR ALTER VIEW pra.qtdFuncionarioESalarios AS
Select
    COUNT(f.idFunc), COUNT(f.salario)
FROM
    pra.Funcionario as f