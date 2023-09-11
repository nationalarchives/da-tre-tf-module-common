locals {
  da_eventbus_principals : var.env == "prod" ?
      [
        "arn:aws:iam::${var.account_id}:root",
        "arn:aws:iam::${var.tdr_account_numbers.prod}:root",
        "arn:aws:iam::${var.dr2_account_numbers.prod}:root"
      ]
      : var.env == "staging" ?
      [
        "arn:aws:iam::${var.account_id}:root",
        "arn:aws:iam::${var.tdr_account_numbers.staging}:root",
        "arn:aws:iam::${var.dr2_account_numbers.staging}:root"
      ]
      : var.env == "int" ?
      [
        "arn:aws:iam::${var.account_id}:root",
        "arn:aws:iam::${var.tdr_account_numbers.intg}:root",
        "arn:aws:iam::${var.dr2_account_numbers.intg}:root"
      ]
      : var.env == "dev" ?
      [
        "arn:aws:iam::${var.account_id}:root",
        "arn:aws:iam::${var.tdr_account_numbers.intg}:root",
        "arn:aws:iam::${var.dr2_account_numbers.intg}:root"
      ]
      : var.env == "test" ?
      [
        "arn:aws:iam::${var.account_id}:root",
        "arn:aws:iam::${var.tdr_account_numbers.intg}:root",
        "arn:aws:iam::${var.dr2_account_numbers.intg}:root"
      ]
      :
      ["arn:aws:iam::${var.account_id}:root"]

}

