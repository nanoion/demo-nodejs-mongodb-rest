db.createUser(
    {
        user: "admin",
        pwd: "welcome1",
        roles: [
            {
                role: "readWrite",
                db: "test"
            }
        ]
    }
);