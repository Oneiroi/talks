from faker import Faker
Faker.seed(0)
fake = Faker()
#USe python Faker to setup Dummy data, output SQL
print("USE CHD;")
for _ in range(1000):
    sql = "INSERT INTO ccInfo (name, address,ccNum,ccEXP,CVCC) VALUES({name},{address},{ccNumber},{ccExp},{CVCC});"
    sql = sql.format(
        name = "'{fullName}'".format(fullName="".join([fake.first_name()," ",fake.last_name()])),
        address = "'" + fake.address().replace("\n"," ") + "'",
        ccNumber = fake.credit_card_number(),
        ccExp = "'" + fake.credit_card_expire() + "'",
        CVCC = fake.credit_card_security_code()
    )
    print(sql)
