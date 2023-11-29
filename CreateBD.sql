--Create schema pra;

CREATE TABLE pra.Cliente (
    CPF_Cliente CHAR (11) not null,
    firNome VARCHAR (15) not null,
    meioNome char (1) not NULL,
    ultNome VARCHAR (15) not null,
    Email VARCHAR (30) not null,
    CEP char (8) not null,
    numCasa SMALLINT not null, 
    aniversario date,
    primary KEY (CPF_Cliente)
);

ALTER TABLE pra.Cliente ALTER COLUMN senha VARCHAR(20)

Create Table pra.Funcionario (
    idFunc char (3) PRIMARY KEY not null,
    fFirNome VARCHAR (15) not null,
    fMeioNome char (1) not NULL,
    fUltNome VARCHAR (15) not null,
    dataNacimento DATE not null,
    salario int not null,
    nivelPrestigio TINYINT not NULL
);
ALTER TABLE pra.Funcionario ALTER COLUMN senha varchar(20) not null;

Create TABLE pra.Produto(
    idProd SMALLINT PRIMARY KEY not null,
    nomeProd VARCHAR (25) not null,
    qtdEstoque SMALLINT not null,
    info text,
    tipo_de_solo VARCHAR (20),
    especie NCHAR
);
ALTER TABLE pra.Produto ALTER COLUMN especie varchar(20) not null;
ALTER TABLE pra.Produto Add valorUnitario int not null;


CREATE TABLE pra.Fornecedor(
    CNPJ char (14) not null PRIMARY KEY,
    devemos bit not null DEFAULT 0,
    valorDivida int,
    materialFornecido SMALLINT,
    FOREIGN KEY (materialFornecido) REFERENCES pra.Produto(idProd)
);

CREATE TABLE pra.Pedido (
    CPF_Cliente char(11) not null,
    idProd   SMALLINT not null,
    qtd_Comprada SMALLINT not null,
    data date not null,
    CEP char (8) not null,
    numCasa SMALLINT not null,
    idFunc char (3) not null ,
    idVenda int primary key IDENTITY not null,

    FOREIGN KEY (CPF_Cliente) REFERENCES pra.Cliente (CPF_Cliente),
    FOREIGN key (idProd) REFERENCES pra.Produto (idProd),
    FOREIGN KEY (idFunc) REFERENCES pra.Funcionario (idFunc)
);

