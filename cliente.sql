CREATE OR ALTER PROCEDURE pra.incluirCliente
as
BEGIN

END


CREATE OR ALTER PROCEDURE pra.excluirCliente
as
BEGIN

END


CREATE OR ALTER TRIGGER pra.clienteMenorIdade on pra.cliente for insert,UPDATE AS
BEGIN
    declare @idade real, @CPF_Cliente char(11)
    select @CPF_Cliente = CPF_Cliente from inserted
    set @idade = DATEDIFF(Year,@data, GetDate())
    if @idade<18
    begin
        Delete from pra.cliente where CPF_Cliente = @CPF_Cliente 
    end
    else
        print ('INCLUSÃO REALIZADA COM SUCESSO')
END 